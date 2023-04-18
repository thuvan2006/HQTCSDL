USE QuanLyBanHang
--Câu 1--
CREATE PROCEDURE sp_THEMNHANVIEN
    @manv VARCHAR,
    @tennv NVARCHAR(50),
    @gioitinh NVARCHAR(10),
    @diachi NVARCHAR(100),
    @sodt VARCHAR(20),
    @email VARCHAR(50),
    @phong NVARCHAR(50),
    @Flag INT
AS
BEGIN
    SET NOCOUNT ON;
    
    --kiểm tra giới tính
    IF @gioitinh NOT IN ('Nam', 'N?')
    BEGIN
        RETURN 1;
    END
    
    --kiểm tra flag
    IF @Flag = 0 
    BEGIN
        INSERT INTO Nhanvien(manv, tennv, gioitinh, diachi, sodt, email, phong)
        VALUES(@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong);
    END
    ELSE
    BEGIN
        UPDATE Nhanvien
        SET tennv = @tennv,
            gioitinh = @gioitinh,
            diachi = @diachi,
            sodt = @sodt,
            email = @email,
            phong = @phong
        WHERE manv = @manv;
    END
    
    RETURN 0;
END

EXEC sp_THEMNHANVIEN 'NV04',N'Thu Vân',N'Nữ',N'tp.hcm','0983416755','van@gmail.com',N'Kế toán',0
---Câu 2---
CREATE PROCEDURE ThemMoiSanPham 
       @masp varchar(10),  
	   @tenhang varchar(50), 
	   @tensp varchar(50), 
	   @soluong int, 
	   @mausac varchar(20), 
	   @giaban float, 
	   @donvitinh varchar(20), 
	   @mota varchar(100), 
	   @Flag bit=0
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra tên hãng sản xuất
    IF NOT EXISTS(SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        SELECT 1 AS 'MaLoi', N'Không tìm thấy tên hãng sản xuất' AS 'MoTaLoi'
        RETURN
    END

    --Kiểm tra số lượng sản phẩm
    IF @soluong < 0
    BEGIN
        SELECT 2 AS 'MaLoi', N'Số lượng sản phẩm phải lớn hơn hoặc bằng 0' AS 'MoTaLoi'
        RETURN
    END

    -- Nếu là thêm mới sản phẩm
    IF @Flag = 0
    BEGIN
        INSERT INTO Sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang), @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)

        SELECT 0 AS 'MaLoi', 'Thêm mới sản phẩm thành công' AS 'MoTaLoi'
    END
    ELSE -- Nếu là cập nhật sản phẩm
    BEGIN
        UPDATE Sanpham
        SET mahangsx = (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang), 
            tensp = @tensp, 
            soluong = @soluong, 
            mausac = @mausac, 
            giaban = @giaban, 
            donvitinh = @donvitinh, 
            mota = @mota
        WHERE masp = @masp

        SELECT 0 AS 'MaLoi', N'Cập nhật sản phẩm thành công' AS 'MoTaLoi'
    END
END

EXEC ThemMoiSanPham 'SP06',N'Điện thoại LG','LG Note','20','Xanh','6500000',N'Chiếc',N'Hàng cao cấp',0
---Câu 3---
CREATE PROCEDURE DeleteNhanVien
    @manv varchar
AS
BEGIN
    -- Kiểm tra xem manv đã tồn tại trong bảng nhanvien hay chưa
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RETURN 1; -- Trả về 1 nếu manv chưa tồn tại trong bảng Nhanvien
    END

    BEGIN TRANSACTION;

    -- Xóa dữ liệu trong bảng Nhap
    DELETE FROM Nhap WHERE manv = @manv;

    -- Xóa dữ liệu trong bảng Xuat
    DELETE FROM Xuat WHERE manv = @manv;

    -- Xóa dữ liệu trong bảng nhanvien
    DELETE FROM nhanvien WHERE manv = @manv;

    COMMIT TRANSACTION; 

    RETURN 0; -- Trả về 0 nếu xóa thành công
END
EXEC DeleteNhanVien'NV001';

---Câu 4---
CREATE PROC [dbo].[spxoasanpham]
	@masp varchar(10)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaSP = @masp)
	BEGIN
		SELECT 1 AS 'ERRORCODE'
		RETURN
	END
	ELSE 
	BEGIN 
	DELETE FROM Nhap WHERE MaSP = @masp
	DELETE FROM Xuat WHERE MaSP = @masp
	DELETE FROM SanPham WHERE MaSP = @masp

	SELECT 0 AS 'ERRORCODE'
	RETURN
	END
END
EXEC dbo.spxoasanpham 'SP04'

---Câu 5---
CREATE PROCEDURE sp_ThemHangsx1
   @mahangsx nchar (10),
   @tenhang nvarchar (20),
   @diachi nvarchar (20),
   @sodt nvarchar (20) ,
   @email nvarchar (30)
AS
BEGIN
     SET NOCOUNT ON;

        IF EXISTS (SELECT * FROM Hangsx WHERE Tenhang = @tenhang)
        BEGIN
        PRINT '1'
        RETURN
    END
        ELSE
        BEGIN
            PRINT 'Không được nhập mã lỗi 0'
        END
END
EXEC sp_ThemHangsx1 'Mahangsx','LG',N'Thailand','01234567',N'lg@gmail.com'
---Câu 6---
create proc [dbo].[spinsertNhap]
	@sohdn varchar(5),
	@masp varchar(5),
	@manv varchar(5),
	@ngaynhap date,
	@soluongN int,
	@dongiaN int
as
BEGIN
    -- Kiểm tra masp có tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS(SELECT masp FROM Sanpham WHERE masp = @masp)
    BEGIN
        -- Trả về mã lỗi 1 nếu masp không tồn tại
        SELECT 1 AS ErrorCode
        RETURN
    END

    -- Kiểm tra manv có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS(SELECT manv FROM Nhanvien WHERE manv = @manv)
    BEGIN
        -- Trả về mã lỗi 2 nếu manv không tồn tại
        SELECT 2 AS ErrorCode
        RETURN
    END

    -- Kiểm tra xem sohdn đã tồn tại chưa
    IF EXISTS(SELECT sohdn FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        -- Nếu đã tồn tại thì cập nhật bảng Nhap
        UPDATE Nhap
        SET masp = @masp, manv = @manv, ngaynhap = @ngaynhap, soluongN = @soluongN, dongiaN = @dongiaN
        WHERE sohdn = @sohdn
    END
    ELSE
    BEGIN
        -- Nếu chưa tồn tại thì thêm mới vào bảng Nhap
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
    END

    -- Trả về mã lỗi 0 nếu thực hiện thành công
    SELECT 0 AS ErrorCode
END


---câu7:  Viết thủ tập nhập dữ liệu cho bảng xuat với các tham biến sohdx, masp, manv, ngayxuat, soluongX. Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không nếu không trả về 1? manv có tồn tại trong bảng nhanvien hay không nếu không trả về 2? soluongX <= Soluong nếu không trả về 3? ngược lại thì hãy kiểm tra: Nếu sohdx đã tồn tại thì cập nhật bảng Xuat theo sohdx, ngược lại thêm mới bảng Xuat và trả về mã lỗi 0*/

CREATE PROCEDURE spNhapDuLieuXuat 
    @sohdx VARCHAR(20),
    @masp VARCHAR(20),
    @manv VARCHAR(20),
    @ngayxuat DATE,
    @soluongX INT
AS
BEGIN
    -- Kiểm tra mã sản phẩm có tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE Masp = @masp)
    BEGIN
        RETURN 1; -- Trả về mã lỗi 1 nếu mã sản phẩm không tồn tại
    END
    
    -- Kiểm tra mã nhân viên có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE Manv = @manv)
    BEGIN
        RETURN 2; -- Trả về mã lỗi 2 nếu mã nhân viên không tồn tại
    END
    
    -- Kiểm tra số lượng xuất có lớn hơn 0 và không vượt quá số lượng sản phẩm tồn kho
    IF @soluongX <= 0 OR @soluongX > (SELECT Soluong FROM Sanpham WHERE Masp = @masp)
    BEGIN
        RETURN 3; -- Trả về mã lỗi 3 nếu số lượng xuất không hợp lệ
    END
    
    -- Kiểm tra nếu sohdx đã tồn tại thì cập nhật bảng Xuat, ngược lại thêm mới bảng Xuat
    IF EXISTS (SELECT * FROM Xuat WHERE Sohdx = @sohdx)
    BEGIN
        UPDATE Xuat
        SET Masp = @masp, Manv = @manv, Ngayxuat = @ngayxuat, SoluongX = @soluongX
        WHERE Sohdx = @sohdx;
    END
    ELSE
    BEGIN
        INSERT INTO Xuat (Sohdx, Masp, Manv, Ngayxuat, SoluongX)
        VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX);
    END
    
    RETURN 0; -- Trả về mã lỗi 0 nếu thêm hoặc cập nhật bảng Xuat thành công
END
