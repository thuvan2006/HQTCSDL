USE QuanLyBanHang
SELECT * FROM SanPham
SELECT * FROM Nhap
SELECT * FROM Xuat
SELECT * FROM Nhanvien
SELECT * FROM Hangsx
---Câu 1---
SELECT Hangsx.Tenhang, COUNT(*) AS SoLuongSanPham 
FROM SanPham inner join Hangsx on SanPham.Mahangsx = Hangsx.Mahangsx 
GROUP BY Hangsx.Tenhang
---Câu 2---
SELECT Nhap.Masp, Sanpham.tensp, SUM(Nhap.soluongN * Nhap.dongiaN) as TongTienNhap
FROM Nhap inner join Sanpham on Nhap.Masp = Sanpham.masp
WHERE  YEAR(Nhap.Ngaynhap)='2018'
GROUP BY Nhap.Masp, Sanpham.tensp
---Câu 3(*)---
SELECT SanPham.tensp, SUM(Xuat.soluongX) as TongSoLuongXuat
FROM SanPham inner join Xuat on SanPham.masp = Xuat.masp
WHERE YEAR(Xuat.ngayxuat) = '2018' and SanPham.mahangsx = 'H01'
GROUP BY SanPham.tensp
HAVING SUM(Xuat.soluongX) > 10000;
---Câu 4---
SELECT Nhanvien.Phong, COUNT(*) as SoLuongNamMoiPhong
FROM Nhanvien
WHERE Nhanvien.Gioitinh=N'Nam'
GROUP BY Nhanvien.Phong
---Câu 5---
SELECT SanPham.mahangsx, Hangsx.Tenhang, SUM(Nhap.soluongN) as TongSoLuongNhap
FROM Nhap inner join SanPham on Nhap.Masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.Mahangsx
WHERE YEAR(Nhap.Ngaynhap)='2018'
GROUP BY SanPham.mahangsx, Hangsx.Tenhang
---Câu 6---
SELECT SUM(Xuat.soLuongX*SanPham.giaban) AS TongLuongTienXuat, Nhanvien.Manv, Nhanvien.Tennv
FROM Nhanvien inner join Xuat on Nhanvien.Manv=Xuat.Manv inner join SanPham on Xuat.Masp=SanPham.masp
WHERE YEAR(Xuat.Ngayxuat)='2018'
GROUP BY Nhanvien.Manv, Nhanvien.Tennv
---Câu 7---
SELECT SUM(Nhap.soluongN * Nhap.dongiaN) as TongTienNhap, Nhanvien.Manv, Nhanvien.Tennv
FROM Nhap inner join Nhanvien on Nhap.Manv=Nhanvien.Manv
WHERE CONVERT(DATE, Nhap.Ngaynhap, 105) between  '2018-08-01' and'2018-08-31'---dùng convert để chuyển đổi định dạng, 105 xác định định dạng ban đầu dd-mm-yyyy của ngày tháng năm
GROUP BY Nhanvien.Manv, Nhanvien.Tennv
HAVING SUM(Nhap.soluongN * Nhap.dongiaN) > 100000;
---Câu 8---
SELECT SanPham.masp, SanPham.tensp
FROM SanPham
WHERE SanPham.masp NOT IN (SELECT masp FROM Xuat)
---Câu 9---
SELECT DISTINCT SanPham.masp, SanPham.tensp
FROM Nhap inner join SanPham on Nhap.Masp=SanPham.masp inner join Xuat on SanPham.masp=Xuat.Masp
WHERE YEAR(Nhap.NgayNhap) = '2018' and YEAR(Xuat.NgayXuat) = '2018'
---Câu 10---
SELECT DISTINCT NhanVien.Manv, NhanVien.Tennv
FROM Nhap inner join Nhanvien on Nhap.Manv=Nhanvien.Manv inner join Xuat on Nhanvien.Manv=Xuat.Manv
---Câu 11---
SELECT Nhanvien.Manv, Nhanvien.Tennv, Nhanvien.Sodt, Nhanvien.Diachi, Nhanvien.email, Nhanvien.Gioitinh, Nhanvien.Phong
FROM Nhap inner join Nhanvien on Nhap.Manv=Nhanvien.Manv inner join Xuat on Nhanvien.Manv=Xuat.Manv
WHERE Nhap.Manv is null and Xuat.Manv is null---is null là hàm toán tử so sánh, kiểm tra các nhân viên không xuất không nhập