USE master
CREATE DATABASE QuanLyBanHang
USE QuanLyBanHang
CREATE TABLE SanPham
(
   masp nchar (10) PRIMARY KEY,
   mahangsx nchar (10) NOT NULL,
   tensp nvarchar (20) NOT NULL,
   soluong int NOT NULL,
   mausac nvarchar (20) NOT NULL,
   giaban money NOT NULL,
   donvitinh nchar (10) NOT NULL,
   mota nvarchar (max)  NOT NULL)
CREATE TABLE Hangsx
(
   Mahangsx nchar (10) PRIMARY KEY,
   Tenhang nvarchar (20) NOT NULL,
   Diachi nvarchar (20) NOT NULL,
   Sodt nvarchar (20) NOT NULL,
   email nvarchar (30) NOT NULL)
CREATE TABLE Nhap
(
   Sohdn nchar (10) NOT NULL,
   Masp nchar (10) NOT NULL,
   Manv nchar (10) NOT NULL,
   Ngaynhap date NOT NULL,
   soluongN int NOT NULL,
   dongiaN money NOT NULL,
   CONSTRAINT pk_1 PRIMARY KEY (Sohdn, Masp))
CREATE TABLE Xuat
( 
   Sohdx nchar (10) NOT NULL,
   Masp nchar (10) NOT NULL,
   Manv nchar (10) NOT NULL,
   Ngayxuat date NOT NULL,
   soluongX int NOT NULL,
   CONSTRAINT pk_2 PRIMARY KEY (Sohdx, Masp))
CREATE TABLE Nhanvien
(
   Manv nchar (10) PRIMARY KEY,
   Tennv nvarchar (20) NOT NULL,
   Gioitinh nchar (10) NOT NULL,
   Diachi nvarchar (30) NOT NULL,
   Sodt nvarchar (20) NOT NULL,
   email nvarchar (30) NOT NULL,
   Phong nvarchar (30) NOT NULL)
ALTER TABLE SanPham
ADD
   CONSTRAINT fk_1 FOREIGN KEY (mahangsx) REFERENCES Hangsx (mahangsx)
   ON DELETE CASCADE
   ON UPDATE CASCADE
ALTER TABLE Nhap
ADD
   CONSTRAINT fk_2 FOREIGN KEY (Masp) REFERENCES Sanpham (masp),
   CONSTRAINT fk_3 FOREIGN KEY (Manv) REFERENCES Nhanvien (manv) 
   ON DELETE CASCADE
   ON UPDATE CASCADE
ALTER TABLE Xuat
ADD
   CONSTRAINT fk_4 FOREIGN KEY (Masp) REFERENCES Sanpham (masp),
   CONSTRAINT fk_5 FOREIGN KEY (Manv) REFERENCES Nhanvien (manv)
   ON DELETE CASCADE
   ON UPDATE CASCADE
INSERT INTO Hangsx
VALUES ('H01',N'SamSung',N'Korea',011-08271717,N'ss@gmail.com.kr'),
       ('H02',N'OPPO',N'China',081-08626262,N'oppo@gmail.com.cn'),
	   ('H03',N'Vinfone',N'Việt Nam',084-098262626,N'vf@gmail.com.vn')
INSERT INTO Nhanvien
VALUES ('NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội','0982626521',N'thu@gmail.com',N'Kế toán'),
       ('NV02',N'Nguyễn Văn Nam',N'Nam',N'Bắc Ninh','0972525252',N'nam@gmail.com',N'Vật tư'),
	   ('NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội','0328388388',N'hb@gmail.com',N'Kế toán')
INSERT INTO Sanpham
VALUES ('SP01','H02','F1 Plus','100',N'Xám','7000000',N'Chiếc',N'Hàng cận cao cấp'),
       ('SP02','H01','Galaxy Note11','50',N'Đỏ','19000000',N'Chiếc',N'Hàng cao cấp'),
	   ('SP03','H02','F3 lite','200',N'Nâu','3000000',N'Chiếc',N'Hàng phổ thông'),
	   ('SP04','H03','Vjoy3','200',N'Xám','1500000',N'Chiếc',N'Hàng phổ thông'),
	   ('SP05','H01','Galaxy V21','500',N'Nâu','8000000',N'Chiếc',N'Hàng cận cao cấp')
INSERT INTO Nhap
VALUES ('N01','SP02','NV01','02-05-2019','10','17000000'),
       ('N02','SP01','NV02','04-07-2020','30','6000000'),
	   ('N03','SP04','NV02','05-17-2020','20','1200000'),
	   ('N04','SP01','NV03','03-22-2020','10','6200000'),
	   ('N05','SP05','NV01','07-07-2020','20','7000000')
INSERT INTO Xuat
VALUES ('X01','SP03','NV02','06-14-2020','5'),
       ('X01','SP01','NV03','03-05-2019','3'),
	   ('X03','SP02','NV01','12-12-2020','1'),
	   ('X04','SP03','NV02','06-02-2020','2'),
	   ('X05','SP05','NV01','05-18-2020','1')

