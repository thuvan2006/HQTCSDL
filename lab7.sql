USE QuanLyBanHang
SELECT * FROM SanPham
SELECT * FROM Nhap
SELECT * FROM Xuat
SELECT * FROM Nhanvien
SELECT * FROM Hangsx
---Câu 1---
CREATE PROCEDURE sp_ThemHangsx
    @mahangsx nvarchar(10),
    @tenhang nvarchar(50),
    @diachi nvarchar(100),
    @sdt nvarchar(20),
    @email nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM Hangsx WHERE Tenhang = @tenhang)
    BEGIN
        PRINT N'Tên hàng đã tồn tại, không thể thêm mới.'
        RETURN
    END

    INSERT INTO Hangsx (Mahangsx, Tenhang, Diachi, Sodt, Email)
    VALUES (@mahangsx, @tenhang, @diachi, @sdt, @email)

    PRINT N'Thêm mới thành công.'
END
EXEC sp_ThemHangsx 'H04', 'Apple', 'USA', '-8123456', 'contact@apple.com'
---Câu 2---(* xài thêm lệnh update  
CREATE PROCEDURE sp_NhapSanPham
    @masp nchar(10),
    @tenhangsx nvarchar(50),
    @tensp nvarchar(50),
    @soluong int,
    @mausac nvarchar(20),
    @giban money,
    @donvitinh nchar(10),
    @mota nvarchar(max)
AS
BEGIN
    DECLARE @mahangsx nchar(10)
    SELECT @mahangsx = Mahangsx FROM Hangsx WHERE Tenhang = @tenhangsx
    
    IF @mahangsx IS NULL
    BEGIN
        PRINT N'Tên hãng sản xuất không tồn tại'
        RETURN
    END
    
    IF EXISTS (SELECT * FROM SanPham WHERE masp = @masp)
    BEGIN
        UPDATE SanPham 
        SET mahangsx = @mahangsx, 
            tensp = @tensp, 
            soluong = @soluong, 
            mausac = @mausac, 
            giaban = @giban, 
            donvitinh = @donvitinh, 
            mota = @mota
        WHERE masp = @masp
    END
    ELSE
    BEGIN
        INSERT INTO SanPham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, @mahangsx, @tensp, @soluong, @mausac, @giban, @donvitinh, @mota)
    END
END

EXEC sp_NhapSanPham 'SP06', 'H04', N'Iphone 14 pro max','100', N'Đen',35990000.00,N'Chiếc',N'Hàng cao cấp'
---Câu 3---
CREATE PROCEDURE sp_XoaHangSX 
    @tenhang nvarchar(20)
AS
BEGIN
    DECLARE @mahangsx nchar(10)
    SELECT @mahangsx = Mahangsx FROM Hangsx WHERE Tenhang = @tenhang

    IF @mahangsx IS NULL
    BEGIN
        PRINT 'Tên hãng sản xuất không tồn tại'
        RETURN
    END

    DELETE FROM SanPham WHERE mahangsx = @mahangsx
    DELETE FROM Hangsx WHERE Tenhang = @tenhang

    PRINT 'Xóa hãng sản xuất thành công'
END
EXEC sp_XoaHangsx N'Samsung'
---Câu 4---
CREATE PROCEDURE sp_NhapNhanVien
    @manv nchar(10),
    @tennv nvarchar(50),
    @gioitinh nvarchar(10),
    @diachi nvarchar(100),
    @sodt nvarchar(20),
    @email nvarchar(50),
    @phong nvarchar(50),
    @Flag bit = 0
AS
BEGIN
    IF (@Flag = 0)
    BEGIN
        IF EXISTS (SELECT * FROM NhanVien WHERE manv = @manv)
        BEGIN
            UPDATE NhanVien 
            SET tennv = @tennv, 
                gioitinh = @gioitinh, 
                diachi = @diachi, 
                sodt = @sodt, 
                email = @email, 
                phong = @phong
            WHERE manv = @manv
        END
        ELSE
        BEGIN
            INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
            VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)
        END
    END
    ELSE
    BEGIN
        PRINT N'Gía trị Flag không hợp lệ nên là 0'
        RETURN
    END
END
EXEC sp_NhapNhanVien 'NV04','Võ Đoan Trang', N'Nữ', N'Tuyên Quang','0912345678',N'trang@gmail.com', N'Vật tư', 0
SELECT * FROM Nhanvien
---Câu 5---
CREATE PROCEDURE sp_NhapHang
    @sohdn nvarchar(20),
    @masp nchar(10),
    @manv nchar(10),
    @ngaynhap date,
    @soluongN int,
    @dongiaN money
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM SanPham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại'
        RETURN
    END
    
    IF NOT EXISTS(SELECT * FROM NhanVien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại'
        RETURN
    END
    
    IF EXISTS(SELECT * FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        UPDATE Nhap 
        SET masp = @masp, 
            manv = @manv, 
            ngaynhap = @ngaynhap, 
            soluongN = @soluongN, 
            dongiaN = @dongiaN
        WHERE sohdn = @sohdn
    END
    ELSE
    BEGIN
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
    END
END
EXEC sp_NhapHang 'N06','SP03','NV04','01-01-2020','10',6000000.00
SELECT * FROM Nhap
---Câu 6---
CREATE PROCEDURE sp_NhapXuat
    @sohdx nvarchar(10),
    @masp nchar(10),
    @manv nvarchar(10),
    @ngayxuat date,
    @soluongX int
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM SanPham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại!'
        RETURN
    END
    
    IF NOT EXISTS (SELECT * FROM NhanVien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại!'
        RETURN
    END
    
    -- Kiểm tra soluongX <= SoLuong?
    DECLARE @Soluong int
    SELECT @Soluong = soluong FROM SanPham WHERE masp = @masp
    IF @soluongX > @Soluong
    BEGIN
        PRINT 'Số lượng xuất vượt quá số lượng trong kho!'
        RETURN
    END
    
    -- Kiểm tra nếu sohdx đã tồn tại thì cập nhật bảng Xuat theo sohdx, ngược lại thêm mới bảng Xuat.
    IF EXISTS (SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        UPDATE Xuat SET masp = @masp, manv = @manv, ngayxuat = @ngayxuat, soluongX = @soluongX WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        INSERT INTO Xuat (sohdx, masp, manv, ngayxuat, soluongX) VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END
END
EXEC sp_NhapXuat 'X06','SP04','NV04','12-21-2020','6'
SELECT * FROM Xuat
---Câu 7---(KHÓ)xem lại 
CREATE PROCEDURE sp_XoaNhanVien
    @manv nchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT * FROM nhanvien WHERE manv = @manv)
    BEGIN
        PRINT N'Không tồn tại nhân viên với mã số ' + @manv;
        RETURN;
    END
    
    BEGIN TRY ---xử lý giao dịch  
        BEGIN TRANSACTION;

        -- Xóa dữ liệu từ bảng Nhap liên quan đến nhân viên này
        DELETE FROM Nhap WHERE manv = @manv;

        -- Xóa dữ liệu từ bảng Xuat liên quan đến nhân viên này
        DELETE FROM Xuat WHERE manv = @manv;

        -- Xóa nhân viên với manv tương ứng
        DELETE FROM nhanvien WHERE manv = @manv;

        COMMIT TRANSACTION;
        PRINT N'Đã xóa nhân viên có mã số ' + @manv + N' thành công.';
    END TRY
    BEGIN CATCH---báo lại lỗi khi giao dịch khối try không thành công
        ROLLBACK TRANSACTION;
        PRINT N'Có lỗi xảy ra khi xóa nhân viên có mã số ' + @manv;
        THROW;
    END CATCH
END
EXEC sp_XoaNhanVien 'NV05'
---Câu 8---KHÓ 
CREATE PROCEDURE sp_XoaSanPham
    @masp nchar(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM sanpham WHERE masp = @masp)
    BEGIN
        PRINT N'Không tồn tại sản phẩm với mã số ' + @masp;
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Xóa dữ liệu từ bảng Nhap liên quan đến sản phẩm này
        DELETE FROM Nhap WHERE masp = @masp;

        -- Xóa dữ liệu từ bảng Xuat liên quan đến sản phẩm này
        DELETE FROM Xuat WHERE masp = @masp;

        -- Xóa sản phẩm với masp tương ứng
        DELETE FROM sanpham WHERE masp = @masp;

        COMMIT TRANSACTION;
        PRINT N'Đã xóa sản phẩm có mã số ' + @masp + N' thành công.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'Có lỗi xảy ra khi xóa sản phẩm có mã số ' + @masp;
        THROW;
    END CATCH
END
EXEC sp_XoaSanPham 'SP001'
