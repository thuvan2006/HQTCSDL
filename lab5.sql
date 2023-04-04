USE QuanLyBanHang
---Câu 1---
create function fn_Timhang(@masp nvarchar(10))
returns nvarchar(20)
as
begin
declare @ten nvarchar(20)
set @ten = (select tenhang from hangsx inner join sanpham
on hangsx.mahangsx = sanpham.mahangsx
where masp = @masp)
return @ten
end
---Câu 2---
create function fn_thongkenhaptheonam(@x int,@y int)
returns int
as
begin
declare @tongtien int
select @tongtien = sum(soluongN*dongiaN)
from nhap
where year(ngaynhap) between @x and @y
return @tongtien
end
---Câu 3---
CREATE FUNCTION ThongKeNhapXuat (@tenSanPham nvarchar(20), @nam int)
RETURNS int
AS
BEGIN
    DECLARE @tongNhap int, @tongXuat int
    
    SELECT @tongNhap = SUM(soluongN), @tongXuat = SUM(soluongX)
    FROM Nhap JOIN SanPham ON Nhap.Masp = SanPham.masp
              JOIN Xuat ON Nhap.Masp = Xuat.Masp
    WHERE SanPham.tensp = @tenSanPham AND YEAR(Nhap.Ngaynhap) = @nam
          AND YEAR(Xuat.Ngayxuat) = @nam

    RETURN @tongNhap - @tongXuat
END
---Câu 4---
CREATE FUNCTION fn_TongGiaTriNhap(@x DATE, @y DATE)
RETURNS MONEY
AS
BEGIN
  DECLARE @tong MONEY;
  SELECT @tong = SUM(DonGian * SoLuongN)
  FROM Nhap
  WHERE ngaynhap BETWEEN @x AND @y;

  IF @tong IS NULL
    SET @tong = 0;

  RETURN @tong;
END
---Câu 5---
CREATE FUNCTION fn_TongGiaTriXuatHangA(@A NVARCHAR(50),@x INT)
RETURNS INT
AS
BEGIN
    DECLARE @TongGiaTriXuat INT
    SELECT @TongGiaTriXuat = SUM(Xuat.SoLuongX * SanPham.GiaBan) 
        FROM Xuat 
        JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
        JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
        WHERE HangSX.TenHang = @A
            AND YEAR(Xuat.ngayxuat) = @x
    
    RETURN @TongGiaTriXuat
END
---Câu 6---
CREATE FUNCTION dem_soluong_NV(@tenphong VARCHAR(50))
RETURNS INT
BEGIN
    DECLARE @dem int ;
    SELECT COUNT(*) into @dem FROM NhanVien WHERE Phong = @tenphong
    RETURN @dem;
END
---Câu 7---
CREATE FUNCTION thongkexuat(@tensp VARCHAR(50), @ngayxuat DATE)
RETURNS INT
AS
BEGIN
    DECLARE @sldaxuat INT;
    SELECT @sldaxuat = SUM(soluongX) FROM Xuat WHERE masp = (SELECT masp FROM Sanpham WHERE tensp = @tensp) AND ngayxuat = @ngayxuat;
    RETURN @sldaxuat;
END;
---Câu 8---
CREATE FUNCTION getSDT_nhanvienXuat (@sohdx int)
RETURNS nvarchar(20)
AS
BEGIN
    DECLARE @manv int
    DECLARE @sodt nvarchar(20)
    
    SELECT @manv = manv FROM Xuat WHERE SoHDX = @sohdx
    
    SELECT @sodt = sdt FROM NhanVien WHERE manv = @manv
    
    RETURN @sodt
END
---Câu 9---
CREATE FUNCTION sp_qty_change_in_year(@x VARCHAR(255), @y INT)
RETURNS INT
BEGIN
    DECLARE qty_change INT;
    SELECT SUM(IFNULL(n.soluongN, 0) - IFNULL(x.soluongX, 0))
    INTO qty_change
    FROM (SELECT masp, SUM(soluongX) AS soluongX
          FROM Xuat
          WHERE YEAR(ngayxuat) = @y
          GROUP BY masp) AS x
    RIGHT JOIN (SELECT masp, SUM(soluongN) AS soluongN
                FROM Nhap
                WHERE YEAR(ngaynhap) = @y
                GROUP BY masp) AS n
    ON x.masp = n.masp
    JOIN Sanpham AS sp ON n.masp = sp.masp
    WHERE sp.tensp = @x;
    RETURN qty_change;
END
---Câu 10---
CREATE FUNCTION fn_TongSoLuongSanPham (@TenHang nvarchar(20))
RETURNS int
AS
BEGIN
   DECLARE @MaHang nchar(10)
   DECLARE @TongNhap int
   DECLARE @TongXuat int
   DECLARE @Tong int

   SELECT @MaHang = Mahangsx FROM Hangsx WHERE Tenhang = @TenHang
   
   SELECT @TongNhap = SUM(soluongN) FROM Nhap WHERE Masp IN (SELECT masp FROM SanPham WHERE mahangsx = @MaHang)
   SELECT @TongXuat = SUM(soluongX) FROM Xuat WHERE Masp IN (SELECT masp FROM SanPham WHERE mahangsx = @MaHang)

   SET @Tong = @TongNhap - @TongXuat

   RETURN @Tong
END
