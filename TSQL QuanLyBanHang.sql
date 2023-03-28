USE QuanLyBanHang
---Câu 1---
SELECT * FROM information_schema.tables

SELECT * FROM SanPham
SELECT * FROM Nhap
SELECT * FROM Xuat
SELECT * FROM Nhanvien
SELECT * FROM Hangsx
---Câu 2---
SELECT SanPham.masp, SanPham.tensp, SanPham.soluong, SanPham.mausac, SanPham.giaban, SanPham.donvitinh, SanPham.mota as 'cau2'
FROM SanPham 
ORDER BY giaban DESC
---Câu 3---
SELECT Hangsx.tenhang, SanPham.tensp 
FROM Hangsx inner join SanPham on Hangsx.mahangsx=SanPham.mahangsx
WHERE tenhang='Samsung' 
---Câu 4---
SELECT Manv, Tennv, Gioitinh, Diachi, Sodt, email, Phong
FROM Nhanvien
WHERE Gioitinh=N'Nữ' and Phong=N'Kế toán'
---Câu 5---
SELECT Nhap.Sohdn, Nhap.Masp, SanPham.tensp, Hangsx.tenhang, Nhap.soluongN*Nhap.dongiaN as tiennhap, SanPham.mausac, SanPham.donvitinh, Nhap.Ngaynhap, Nhanvien.Tennv, Nhanvien.Phong
FROM Nhanvien inner join Nhap on Nhanvien.manv=Nhap.manv inner join SanPham on Nhap.masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.mahangsx
ORDER BY Nhap.Sohdn ASC
---Câu 6---
SELECT Xuat.Sohdx, Xuat.Masp, SanPham.tensp, Hangsx.tenhang, Xuat.soluongX*SanPham.giaban as tienxuat,SanPham.mausac,SanPham.donvitinh, Xuat.Ngayxuat,Nhanvien.Tennv,Nhanvien.Phong
FROM Nhanvien inner join Xuat on Nhanvien.manv=Xuat.manv inner join SanPham on Xuat.masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.mahangsx
WHERE YEAR(Xuat.Ngayxuat)='2018'
ORDER BY Xuat.Sohdx ASC
---Câu 7---
SELECT Nhap.Sohdn, Nhap.Masp, SanPham.tensp, Nhap.soluongN, Nhap.dongiaN, Nhap.Ngaynhap, Nhanvien.Tennv,Nhanvien.Phong, Hangsx.tenhang
FROM Nhanvien inner join Nhap on Nhanvien.manv=Nhap.manv inner join SanPham on Nhap.masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.mahangsx
WHERE tenhang='Samsung' and YEAR(Nhap.Ngaynhap)='2017'
---Câu 8---
SELECT TOP 10 Xuat.Sohdx, Xuat.masp, SanPham.tensp, HangSX.tenhang, Xuat.soluongX, SanPham.giaban, Xuat.soLuongX*SanPham.giaban AS TienXuat, SanPham.mauSac, SanPham.donvitinh, Xuat.ngayxuat, NhanVien.Tennv, NhanVien.Phong
FROM Nhanvien inner join Xuat on Nhanvien.manv=Xuat.manv inner join SanPham on Xuat.masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.mahangsx
WHERE YEAR(Xuat.ngayxuat) = '2008'
ORDER BY Xuat.soluongX DESC
---Câu 9---
SELECT TOP 10 *
FROM SanPham
ORDER BY giaban DESC
---Câu 10---
SELECT Hangsx.tenhang, SanPham.tensp, SanPham.giaban
FROM Hangsx inner join SanPham on Hangsx.mahangsx=SanPham.mahangsx
WHERE Hangsx.tenhang='Samsung' and SanPham.giaban between 100000 and 500000
---Câu 11---
SELECT SUM(Nhap.dongiaN * Nhap.soluongN) as tongtiennhap
FROM Hangsx inner join SanPham on Hangsx.mahangsx=SanPham.mahangsx inner join Nhap on SanPham.masp=Nhap.Masp
WHERE Hangsx.tenhang='Samsung' and YEAR(Nhap.Ngaynhap)='2018'
---Câu 12---
SELECT SUM(Xuat.soluongX * SanPham.giaban) as tongtienxuat
FROM Xuat inner join SanPham on Xuat.masp=SanPham.masp
WHERE Xuat.Ngayxuat='02-09-2018'
---Câu 13-----------
SELECT Nhap.dongiaN* Nhap.soluongN as tiennhap, Nhap.Sohdn, Nhap.Ngaynhap
FROM Nhap
WHERE YEAR(Nhap.Ngaynhap)='2018'
ORDER BY tiennhap DESC
---Câu 14---
SELECT TOP 10 Nhap.soluongN, Nhap.masp, SanPham.tensp, Nhap.Ngaynhap
FROM Nhap inner join SanPham on Nhap.masp=SanPham.masp
WHERE YEAR(Nhap.Ngaynhap)='2019' 
ORDER BY Nhap.soluongN DESC 
---Câu 15---
SELECT Hangsx.tenhang, SanPham.tensp, Nhap.manv
FROM Hangsx inner join SanPham on Hangsx.mahangsx=SanPham.mahangsx inner join Nhap on SanPham.masp=Nhap.masp
WHERE tenhang='Samsung' and Nhap.manv='NV01'
---Câu 16---
SELECT Nhap.Manv, Nhap.Masp, Nhap.soluongN, Nhap.Ngaynhap
FROM Nhap
WHERE Nhap.Masp='SP02' and Nhap.Manv='NV02'
---Câu 17---
SELECT Xuat.Manv, Nhanvien.Tennv
FROM Xuat inner join Nhanvien on Xuat.Manv=Nhanvien.Manv
WHERE Xuat.Masp='SP02' and Xuat.Ngayxuat='03-02-2020'
