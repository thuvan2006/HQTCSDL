USE QuanLyBanHang
---Câu 1---
CREATE TRIGGER trg_Nhap_Insert ON Nhap
FOR INSERT
AS
BEGIN
    -- Kiểm tra ràng buộc toàn vẹn
    IF NOT EXISTS (SELECT * FROM SanPham WHERE masp IN (SELECT Masp FROM inserted))
    BEGIN
        RAISERROR('Mã sản phẩm không hợp lệ', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    IF NOT EXISTS (SELECT * FROM NhanVien WHERE manv IN (SELECT Manv FROM inserted))
    BEGIN
        RAISERROR('Mã nhân viên không hợp lệ', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    IF EXISTS (SELECT * FROM inserted WHERE soluongN <= 0 OR dongiaN <= 0)
    BEGIN
        RAISERROR('Số lượng và đơn giá phải lớn hơn 0', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    UPDATE SanPham
    SET soluong = soluong + inserted.soluongN
    FROM SanPham
    INNER JOIN inserted ON SanPham.masp = inserted.masp
END

---Câu 2---
CREATE TRIGGER trig_Xuat_Insert
ON Xuat
AFTER INSERT
AS
BEGIN
    DECLARE @Masp nchar(10), @Manv nchar(10), @soluongX int, @soluong int

    SELECT @Masp = i.Masp, @Manv = i.Manv, @soluongX = i.soluongX
    FROM inserted i

    -- Kiểm tra Masp có trong bảng SanPham không
    IF NOT EXISTS (SELECT * FROM SanPham WHERE masp = @Masp)
    BEGIN
        RAISERROR('Masp không tồn tại trong bảng SanPham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Kiểm tra Manv có trong bảng Nhanvien không
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @Manv)
    BEGIN
        RAISERROR('Manv không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Kiểm tra soluongX < soluong trong bảng SanPham
    SELECT @soluong = soluong FROM SanPham WHERE masp = @Masp
    IF @soluongX > @soluong
    BEGIN
        RAISERROR('Số lượng xuất lớn hơn số lượng trong kho', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Cập nhật số lượng trong bảng SanPham sau khi xuất
    UPDATE SanPham SET soluong = soluong - @soluongX WHERE masp = @Masp

END

---Câu 3---
CREATE TRIGGER tr_del_xuat ON Xuat
AFTER DELETE
AS
BEGIN
    UPDATE SanPham
    SET soluong = soluong + d.soluongX
    FROM SanPham AS sp
    JOIN deleted AS d ON sp.masp = d.masp;
END

---Câu 4---
CREATE TRIGGER update_soluongxuat
ON Xuat
AFTER UPDATE
AS
BEGIN
   DECLARE @soluongX INT;
   DECLARE @masp NCHAR(10);
   DECLARE @soluongN INT;

   SELECT @masp = Masp, @soluongX = soluongX FROM inserted;

   -- Kiểm tra số lượng xuất thay đổi có nhỏ hơn số lượng trong bảng sản phẩm hay không?
   SELECT @soluongN = soluong FROM SanPham WHERE masp = @masp;
   IF @soluongX > @soluongN
   BEGIN
      RAISERROR('Số lượng xuất không được vượt quá số lượng trong kho', 16, 1);
      ROLLBACK TRANSACTION;
   END

   -- Kiểm tra số bản ghi thay đổi >1 bản ghi hay không?
   IF (SELECT COUNT(*) FROM inserted) > 1
   BEGIN
      RAISERROR('Chỉ được phép cập nhật 1 bản ghi tại một thời điểm', 16, 1);
      ROLLBACK TRANSACTION;
   END

   -- Nếu thỏa mãn thì cho phép update bảng xuất và update lại số lượng trong bản sản phẩm
   UPDATE Xuat
   SET soluongX = @soluongX
   WHERE Sohdx IN (SELECT Sohdx FROM inserted);

   UPDATE SanPham
   SET soluong = soluong - @soluongX
   WHERE masp = @masp;
END;

---Câu 5---
CREATE TRIGGER update_soluong_nhap
ON Nhap
AFTER UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 1 -- kiểm tra số bản ghi thay đổi
    BEGIN
        PRINT 'Không thể cập nhật số lượng Nhập!'
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        DECLARE @soluong_nhap INT, @soluong_cu INT, @masp NCHAR(10)

        SELECT @masp = i.Masp, @soluong_nhap = i.soluongN, @soluong_cu = d.soluongN
        FROM inserted i
        INNER JOIN deleted d ON i.Sohdn = d.Sohdn AND i.Masp = d.Masp

        UPDATE SanPham SET soluong = soluong - @soluong_cu + @soluong_nhap
        WHERE masp = @masp
    END
END
---Câu 6---
CREATE TRIGGER tr_del_nhap ON Nhap
AFTER DELETE
AS
BEGIN
    UPDATE SanPham
    SET soluong = soluong - d.soluongN
    FROM SanPham AS sp
    JOIN deleted AS d ON sp.masp = d.masp;
END