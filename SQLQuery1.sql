-- Tạo Database DA_QLCT
Create Database DA_QLCT
-- Sử dụng database DA_QLCT
Use DA_QLCT


-- Tạo bảng Tài Khoản
CREATE TABLE TaiKhoan
(
    TenDangNhap NVARCHAR(50) PRIMARY KEY,
    MatKhau NVARCHAR(50),
    HoTen NVARCHAR(50),
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    SDT NVARCHAR(15),
    DiaChi NVARCHAR(100),
    LoaiTaiKhoan NVARCHAR(50)
)

-- Cập nhật loại tài khoản thành ADMIN cho người dùng 'Tref'
UPDATE TaiKhoan
SET LoaiTaiKhoan = 'ADMIN'
WHERE TenDangNhap = 'Tref';


-- Tạo stored procedure để kiểm tra tài khoản
CREATE PROCEDURE CheckTaiKhoan
    @taikhoan NVARCHAR(50),
    @matkhau NVARCHAR(50),
    @loai NVARCHAR(50)
AS
BEGIN
    SELECT COUNT(*) FROM TaiKhoan
    WHERE TenDangNhap = @taikhoan AND MatKhau = @matkhau AND LoaiTaiKhoan = @loai;
END

-- Tạo stored procedure để thay đổi mật khẩu của tài khoản
CREATE PROCEDURE DoiMatKhauTaiKhoan
    @taikhoan NVARCHAR(50),
    @matkhaumoi NVARCHAR(50)
AS
BEGIN
    UPDATE TaiKhoan
    SET MatKhau = @matkhaumoi
    WHERE TenDangNhap = @taikhoan;

    IF @@ROWCOUNT > 0
        SELECT 1 AS Result
    ELSE
        SELECT 0 AS Result
END

-- Tạo stored procedure để cập nhật thông tin của tài khoản
CREATE PROCEDURE CapNhatTaiKhoan
    @taikhoan NVARCHAR(50),
    @hoten NVARCHAR(50),
    @gioitinh NVARCHAR(10),
    @ngaysinh DATE,
    @sdt NVARCHAR(15),
    @diachi NVARCHAR(100)
AS
BEGIN
    UPDATE TaiKhoan
    SET HoTen = @hoten, GioiTinh = @gioitinh, NgaySinh = @ngaysinh, SDT = @sdt, DiaChi = @diachi
    WHERE TenDangNhap = @taikhoan;

    IF @@ROWCOUNT > 0
        SELECT 1 AS Result
    ELSE
        SELECT 0 AS Result
END

-- Tạo stored procedure để xóa tài khoản
CREATE PROCEDURE XoaTaiKhoan
    @taikhoan NVARCHAR(50)
AS
BEGIN
    DELETE FROM TaiKhoan
    WHERE TenDangNhap = @taikhoan;

    IF @@ROWCOUNT > 0
        SELECT 1 AS Result
    ELSE
        SELECT 0 AS Result
END


-- Tạo stored procedure để thêm tài khoản
CREATE PROCEDURE ThemTaiKhoan
    @taikhoan NVARCHAR(50),
    @matkhau NVARCHAR(50),
    @hoten NVARCHAR(50),
    @gioitinh NVARCHAR(10),
    @ngaysinh DATE,
    @sdt NVARCHAR(15),
    @diachi NVARCHAR(100),
    @loaitaikhoan NVARCHAR(50)
AS
BEGIN
    INSERT INTO TaiKhoan(TenDangNhap, MatKhau, HoTen, GioiTinh, NgaySinh, SDT, DiaChi, LoaiTaiKhoan)
    VALUES (@taikhoan, @matkhau, @hoten, @gioitinh, @ngaysinh, @sdt, @diachi, @loaitaikhoan);

    RETURN @@ROWCOUNT;
END

-- Tạo bảng Phương Thức Thanh Toán
CREATE TABLE PhuongThucThanhToan
(
    MaPhuongThucThanhToan NVARCHAR(50) PRIMARY KEY,
    TenPhuongThucThanhToan NVARCHAR(50)
)

-- Tạo bảng Danh Mục Thu
CREATE TABLE DanhMucThu
(
    MaDanhMuc NVARCHAR(50) PRIMARY KEY,
    TenDanhMuc NVARCHAR(50)
)


-- Thêm dữ liệu vào bảng Danh Mục Thu
INSERT INTO DanhMucThu (MaDanhMuc, TenDanhMuc)
VALUES 
('DM01', N'Lương'), 
('DM02', N'Đòi nợ'), 
('DM03', N'Tiền cho thuê nhà'),
('DM04', N'Bán hàng'),
('DM05', N'Đầu tư');


-- Thêm dữ liệu vào bảng PhuongThucThanhToan
INSERT INTO PhuongThucThanhToan (MaPhuongThucThanhToan, TenPhuongThucThanhToan)
VALUES 
('PT01', N'Tiền mặt'), 
('PT02', N'Chuyển khoản'),
('PT04`', N'Dạng háng'),
('PT03', N'Thẻ');
-- Lấy dữ liệu từ bảng Danh Mục Thu
select* from DanhMucThu
-- Lấy dữ liệu từ bảng PhuongThucThanhToan
select*from PhuongThucThanhToan





-- Tạo bảng Chi Tiết Giao Dịch Thu
CREATE TABLE CTGiaoDichThu
(
    MaGiaoDich INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap NVARCHAR(50) FOREIGN KEY REFERENCES TaiKhoan(TenDangNhap),
    MaDanhMuc NVARCHAR(50) FOREIGN KEY REFERENCES DanhMucThu(MaDanhMuc),
    MaPhuongThucThanhToan NVARCHAR(50) FOREIGN KEY REFERENCES PhuongThucThanhToan(MaPhuongThucThanhToan),
    SoTien DECIMAL(18, 2),
    MoTa NVARCHAR(MAX),
    NgayGiaoDich DATE
)

-- Tạo stored procedure để cập nhật giao dịch thu
CREATE PROCEDURE CapNhatGiaoDichThu
    @magiaodich NVARCHAR(50),
    @taikhoan NVARCHAR(50),
    @madanhmuc NVARCHAR(50),
    @maphuongthucthanhtoan NVARCHAR(50),
    @sotien DECIMAL(18, 2),
    @mota NVARCHAR(MAX),
    @ngaygiaodich DATE
AS
BEGIN
    UPDATE CTGiaoDichThu
    SET TenDangNhap = @taikhoan, MaDanhMuc = @madanhmuc, MaPhuongThucThanhToan = @maphuongthucthanhtoan, SoTien = @sotien, MoTa = @mota, NgayGiaoDich = @ngaygiaodich
    WHERE MaGiaoDich = @magiaodich;
END



-- Tạo stored procedure để thêm giao dịch thu
CREATE PROCEDURE ThemGiaoDichThu
    @taikhoan NVARCHAR(50),
    @madanhmuc NVARCHAR(50),
    @maphuongthucthanhtoan NVARCHAR(50),
    @sotien DECIMAL(18, 2),
    @mota NVARCHAR(MAX),
    @ngaygiaodich DATE
AS
BEGIN
    INSERT INTO CTGiaoDichThu(TenDangNhap, MaDanhMuc, MaPhuongThucThanhToan, SoTien, MoTa, NgayGiaoDich)
    VALUES (@taikhoan, @madanhmuc, @maphuongthucthanhtoan, @sotien, @mota, @ngaygiaodich);
END


-- Lấy dữ liệu từ bảng CTGiaoDichThu
SELECT CTGiaoDichThu.MaGiaoDich, TenDangNhap, CTGiaoDichThu.MaDanhMuc,TenDanhMuc, SoTien, MoTa, NgayGiaoDich,
CTGiaoDichThu.MaPhuongThucThanhToan , TenPhuongThucThanhToan 
FROM CTGiaoDichThu 
INNER JOIN DanhMucThu ON CTGiaoDichThu.MaDanhMuc = DanhMucThu.MaDanhMuc 
INNER JOIN PhuongThucThanhToan ON CTGiaoDichThu.MaPhuongThucThanhToan = PhuongThucThanhToan.MaPhuongThucThanhToan;



-- Tạo bảng Danh Mục Chi
CREATE TABLE DanhMucChi
(
    MaDanhMuc NVARCHAR(50) PRIMARY KEY,
    TenDanhMuc NVARCHAR(50)
)


-- Thêm dữ liệu vào bảng
INSERT INTO DanhMucChi(MaDanhMuc, TenDanhMuc)
VALUES 
('DM01', N'Yêu đương'), 
('DM02', N'Ăn chơi'), 
('DM03', N'Chăm sóc sức khỏe'),
('DM04', N'Mua sắm'),
('DM05', N'Đầu tư'),
('DM06', N'Trả nợ');


-- Lấy dữ liệu từ bảng
select* from DanhMucChi
select*from PhuongThucThanhToan



-- Tạo bảng CTGiaoDichChi
CREATE TABLE CTGiaoDichChi
(
    MaGiaoDich INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap NVARCHAR(50),
    MaDanhMuc NVARCHAR(50) FOREIGN KEY REFERENCES DanhMucChi(MaDanhMuc),
    MaPhuongThucThanhToan NVARCHAR(50) FOREIGN KEY REFERENCES PhuongThucThanhToan(MaPhuongThucThanhToan),
    SoTien DECIMAL(18, 2),
    MoTa NVARCHAR(MAX),
    NgayGiaoDich DATE,
    FOREIGN KEY (TenDangNhap) REFERENCES TaiKhoan(TenDangNhap) ON DELETE CASCADE
)


ALTER TABLE CTGiaoDichChi
DROP CONSTRAINT FK__CTGiaoDic__TenDa__1332DBDC

ALTER TABLE CTGiaoDichChi
ADD CONSTRAINT FK__CTGiaoDic__TenDa__1332DBDC FOREIGN KEY (TenDangNhap)
REFERENCES TaiKhoan(TenDangNhap) ON DELETE CASCADE



-- Tạo stored procedure để cập nhật giao dịch chi
CREATE PROCEDURE CapNhatGiaoDichChi
    @magiaodich NVARCHAR(50),
    @taikhoan NVARCHAR(50),
    @madanhmuc NVARCHAR(50),
    @maphuongthucthanhtoan NVARCHAR(50),
    @sotien DECIMAL(18, 2),
    @mota NVARCHAR(MAX),
    @ngaygiaodich DATE
AS
BEGIN
    UPDATE CTGiaoDichChi
    SET TenDangNhap = @taikhoan,
        MaDanhMuc = @madanhmuc,
        MaPhuongThucThanhToan = @maphuongthucthanhtoan,
        SoTien = @sotien,
        MoTa = @mota,
        NgayGiaoDich = @ngaygiaodich
    WHERE MaGiaoDich = @magiaodich;
END



-- Tạo stored procedure để thêm giao dịch chi
CREATE PROCEDURE ThemGiaoDichChi
    @taikhoan NVARCHAR(50),
    @madanhmuc NVARCHAR(50),
    @maphuongthucthanhtoan NVARCHAR(50),
    @sotien DECIMAL(18, 2),
    @mota NVARCHAR(MAX),
    @ngaygiaodich DATE
AS
BEGIN
    INSERT INTO CTGiaoDichChi(TenDangNhap, MaDanhMuc, MaPhuongThucThanhToan, SoTien, MoTa, NgayGiaoDich)
    VALUES (@taikhoan, @madanhmuc, @maphuongthucthanhtoan, @sotien, @mota, @ngaygiaodich);
END



-- Lấy dữ liệu từ bảng CTGiaoDichChi
SELECT CTGiaoDichChi.MaGiaoDich, TenDangNhap, CTGiaoDichChi.MaDanhMuc, TenDanhMuc, SoTien, MoTa, NgayGiaoDich,
CTGiaoDichChi.MaPhuongThucThanhToan , TenPhuongThucThanhToan 
FROM CTGiaoDichChi 
INNER JOIN DanhMucChi ON CTGiaoDichChi.MaDanhMuc = DanhMucChi.MaDanhMuc 
INNER JOIN PhuongThucThanhToan ON CTGiaoDichChi.MaPhuongThucThanhToan = PhuongThucThanhToan.MaPhuongThucThanhToan;





-- Lấy dữ liệu từ bảng Tài Khoản
select *from TaiKhoan



