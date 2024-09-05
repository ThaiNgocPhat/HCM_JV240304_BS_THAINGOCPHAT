CREATE DATABASE crm;
USE crm;
drop database crm;

-- Tạo bảng Books
CREATE TABLE Books(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    book_title VARCHAR(100) NOT NULL,
    book_author VARCHAR(100) NOT NULL
);

-- Tạo bảng Readers
CREATE TABLE Readers(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100)
);

-- Tạo chỉ mục cho trường name trong bảng Readers
CREATE INDEX idx_name ON Readers(name);

-- Tạo bảng BorrowingRecords
CREATE TABLE BorrowingRecords(
    id INT PRIMARY KEY AUTO_INCREMENT,
    borrow_date DATE NOT NULL,
    return_date DATE,
    book_id INT,
    reader_id INT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (reader_id) REFERENCES Readers(id)
);

-- Thêm dữ liệu vào bảng Books
INSERT INTO Books(book_title, book_author) VALUES
('Tấm Cám', 'Nguyễn Khoa Đăng'),
('Dế Mèn Phiêu Lưu Ký', 'Tô Hoài'),
('Số Đỏ', 'Vũ Trọng Phụng'),
('Nhà Giả Kim', 'Paulo Coelho'),
('Chí Phèo', 'Nam Cao');

-- Thêm dữ liệu vào bảng Readers
INSERT INTO Readers(name, phone, email) VALUES
('Nguyen Van A', '0122256789', 'a@gmail.com'),
('Nguyen Van B', '0987654321', 'b@gmail.com'),
('Nguyen Van C', '0123456789', 'c@gmail.com'),
('Nguyen Van D', '0987123456', 'd@gmail.com'),
('Nguyen Van E', '0912345678', 'e@gmail.com'),
('Nguyen Van F', '0934567890', 'f@gmail.com'),
('Nguyen Van G', '0978123456', 'g@gmail.com'),
('Nguyen Van H', '0167123456', 'h@gmail.com'),
('Nguyen Van I', '0129123456', 'i@gmail.com'),
('Nguyen Van J', '0121234567', 'j@gmail.com'),
('Nguyen Van K', '0915123456', 'k@gmail.com'),
('Nguyen Van L', '0909123456', 'l@gmail.com'),
('Nguyen Van M', '0933123456', 'm@gmail.com'),
('Nguyen Van N', '0928123456', 'n@gmail.com'),
('Nguyen Van O', '0946123456', 'o@gmail.com');

-- Thêm dữ liệu vào bảng BorrowingRecords
INSERT INTO BorrowingRecords(borrow_date, return_date, book_id, reader_id) VALUES
('2024-09-01', '2024-09-10', 1, 1),
('2024-09-02', '2024-09-12', 2, 2),
('2024-09-03', '2024-09-15', 3, 3);


-- 1. Lấy tất cả các giao dịch mượn sách
SELECT 
    b.book_title AS 'Tên sách',
    r.name AS 'Tên độc giả',
    br.borrow_date AS 'Ngày mượn sách',
    br.return_date AS 'Ngày trả sách'
FROM
    BorrowingRecords br
JOIN
    Books b ON br.book_id = b.book_id
JOIN 
    Readers r ON br.reader_id = r.id;

-- 2. Tìm tất cả các sách mà độc giả 'Nguyen Van A' đã mượn
SELECT 
    b.book_title AS 'Tên sách',
    r.name AS 'Tên độc giả',
    br.borrow_date AS 'Ngày mượn sách',
    br.return_date AS 'Ngày trả sách'
FROM
    BorrowingRecords br
JOIN
    Books b ON br.book_id = b.book_id
JOIN
    Readers r ON br.reader_id = r.id
WHERE r.name = 'Nguyen Van A';

-- 3. Đếm số lần một cuốn sách đã được mượn
SELECT
    b.book_title AS 'Tên sách',
    COUNT(*) AS 'Số lần mượn'
FROM 
    Books b
JOIN
    BorrowingRecords br ON b.book_id = br.book_id
GROUP BY b.book_title;

-- 4. Truy vấn tên của độc giả đã mượn nhiều sách nhất
SELECT
    r.name AS 'Tên độc giả',
    COUNT(*) AS 'Số sách đã mượn'
FROM 
    Readers r
JOIN
    BorrowingRecords br ON r.id = br.reader_id
GROUP BY r.name
ORDER BY COUNT(*) DESC
LIMIT 1;
