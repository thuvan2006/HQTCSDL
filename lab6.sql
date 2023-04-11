USE QuanLyBanHang
SELECT * FROM SanPham
SELECT * FROM Nhap
SELECT * FROM Xuat
SELECT * FROM Nhanvien
SELECT * FROM Hangsx
---Câu 1---
CREATE FUNCTION Getthongtinsanpham (@tensp nvarchar(20))
RETURNS TABLE
AS
RETURN 
SELECT *
FROM SanPham
WHERE SanPham.tensp = @tensp
SELECT * FROM Getthongtinsanpham('F3 lite')
---Câu 2---
CREATE FUNCTION Getdanhsachcacsanpham (@x DATE, @y DATE)
RETURNS TABLE
AS
RETURN 
    SELECT sp.tensp, hs.tenhang
    FROM SanPham sp
    INNER JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
    INNER JOIN Nhap n ON sp.masp = n.masp
    WHERE n.ngaynhap >= @x AND n.ngaynhap <= @y
SELECT * FROM Getdanhsachcacsanpham('2020-01-01', '2020-12-31');
---Câu 3---
CREATE FUNCTION fn_GetProductByManufacturer(@manufacturer NVARCHAR(50), @option INT)
RETURNS TABLE
AS
RETURN
    SELECT sp.masp, sp.tensp, sp.soluong
    FROM Sanpham sp
    INNER JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
    WHERE hs.tenhang = @manufacturer AND (@option = 0 AND sp.soluong = 0 OR @option = 1 AND sp.soluong > 0)
SELECT *FROM fn_GetProductByManufacturer('Samsung', 1)
---Câu 4---
CREATE FUNCTION Getthongtinnhanvien (@Phong nvarchar(30))
RETURNS TABLE
AS
RETURN 
SELECT *
FROM Nhanvien
WHERE Nhanvien.Phong = @Phong
SELECT * FROM Getthongtinnhanvien(N'Kế toán');
---Câu 5---
CREATE FUNCTION Getthongtinhhangsx (@Diachi nvarchar(20))
RETURNS TABLE
AS
RETURN 
SELECT *
FROM Hangsx
WHERE Diachi LIKE '%'+@Diachi+'%'
SELECT * FROM Getthongtinhhangsx(N'Korea');
---Câu 6---
CREATE FUNCTION GetDanhSachSanPhamXuat(@year1 int, @year2 int)
RETURNS TABLE
AS 
RETURN (
    SELECT SanPham.tensp, Hangsx.Tenhang
    FROM SanPham 
    INNER JOIN Hangsx ON SanPham.mahangsx = Hangsx.Mahangsx 
    INNER JOIN Xuat ON SanPham.masp = Xuat.masp
    WHERE YEAR(Xuat.Ngayxuat) BETWEEN @year1 AND @year2
)
SELECT * FROM GetDanhSachSanPhamXuat('2019','2020');
---Câu 7---
CREATE FUNCTION DANHSACHSANPHAM1 (@Mahangsx CHAR(10), @LUACHON INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT SP.masp, SP.tensp, SP.mausac, SP.giaban, SP.donvitinh,
        CASE 
            WHEN @LUACHON = 0 THEN Nhap.Ngaynhap
            WHEN @LUACHON = 1 THEN Xuat.Ngayxuat
        END AS 'NGAYNHAPXUAT'
    FROM SANPHAM SP
    LEFT JOIN Nhap BN ON SP.masp = Nhap.Masp
    LEFT JOIN Xuat BX ON SP.masp = Xuat.Masp
    WHERE SP.mahangsx = @Mahangsx AND (@LUACHON = 0 OR @LUACHON = 1)
)
select * from DANHSACHSANPHAM1(N'H01',1)
---Câu 8---
CREATE FUNCTION Getthongtinnhanviennhap (@Ngaynhap date)
RETURNS TABLE
AS
RETURN 
SELECT Nhanvien.Tennv
FROM Nhanvien inner join Nhap on Nhanvien.Manv=Nhap.Manv
WHERE Nhap.Ngaynhap = @Ngaynhap
SELECT * FROM Getthongtinnhanviennhap('02-05-2019');
---Câu 9---
CREATE FUNCTION GetDanhSachSanPhamgiaban (@x MONEY, @y MONEY, @z nvarchar(20))
RETURNS TABLE
AS
RETURN 
SELECT SanPham.masp, SanPham.tensp, SanPham.giaban, Hangsx.Tenhang
FROM SanPham 
INNER JOIN Hangsx ON SanPham.mahangsx = Hangsx.Mahangsx
INNER JOIN Nhap ON SanPham.masp = Nhap.masp
WHERE SanPham.giaban >= @x AND SanPham.giaban <= @y AND Hangsx.Tenhang = @z
SELECT * FROM GetDanhSachSanPhamgiaban('8000000.00','19000000.00',N'SamSung');
---Câu 10---
CREATE FUNCTION GetDanhSachSanPhamVaHangSX ()
RETURNS TABLE
AS
RETURN 
SELECT SanPham.masp, SanPham.tensp, SanPham.giaban, Hangsx.Tenhang
FROM SanPham 
INNER JOIN Hangsx ON SanPham.mahangsx = Hangsx.Mahangsx
SELECT *
FROM GetDanhSachSanPhamVaHangSX()

