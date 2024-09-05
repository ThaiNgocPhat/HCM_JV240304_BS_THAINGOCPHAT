create database crm;
use crm;


-- BẢNG BOOKS
create table Books(
    book_id int primary key auto_increment,
    book_title varchar(100) not null,
    book_author varchar(100) not null
);


-- BẢNG READERS
create table Readers(
    id int primary key auto_increment,
    name varchar(150) not null,
    phone varchar(11) not null unique,
    email varchar(100),
);
-- TẠO INDEX CHO TRƯỜNG NAME
create index idx_name ON Readers(name);


-- TẠO BẢNG BORROWINGRECORDS
create table BorrowingRecords(
    id int primary key auto_increment,
    borrow_date date not null,
    return_date date,
    book_id int,
    reader_id int,
    foreign key (book_id) references Books(book_id),
    foreign key (reader_id) references Readers(id)
);


-- THÊM DỮ LIỆU CHO BẢNG

-- THÊM DỮ LIỆU CHO BẢNG BOOK : 5 DŨE LIỆU
insert into Books(book_title, book_author) values
('Tấm Cám', 'Nguyễn Khoa Đăng'),
('Dế Mèn Phiêu Lưu Ký', 'Tô Hoài'),
('Số Đỏ', 'Vũ Trọng Phụng'),
('Nhà Giả Kim', 'Paulo Coelho'),
('Chí Phèo', 'Nam Cao');


-- THÊM DỮ LIỆU CHO READERS : 15 DỮ LIỆU
insert into Readers(name, phone, email) values
('Nguyen Van A', '0123456789', 'a@gmail.com'),
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

-- THÊM DỮ LIỆU CHO BẢNG BORROWINGRECORDS : 3 DỮ LIỆU
insert into BorrowingRecords(borrow_date, return_date, book_id, reader) values
('2024-09-01', '2024-09-10', 1, 1),
('2024-09-02', '2024-09-12', 2, 2),
('2024-09-03', '2024-09-15', 3, 3);

-- TRUY VẤN DỮ LIỆU

-- -------------YÊU CẦU 1----------
-- 1.Lấy tất cả các giao dịch mượn sách, bao gồm tên sách, tên độc giả, ngày mượn, và ngày trả
select 
    b.book_title as 'Tên sách',
    r.name as 'Tên độc giả',
    br.borrow_date as 'Ngày mượn sách',
    br.return_date as 'Ngày trả sách'
from
    BorrowingRecords br
join
    Books b on br.book_id = b.book_id
join 
    Readers r on br.reader_id = r.id;


-- 2.Tìm tất cả các sách mà độc giả bất kỳ đã mượn(ví dụ : độc giả có tên là Nguyen Van A)
select 
    b.book_title as 'Tên sách',
    r.name as 'Tên độc giả',
    br.borrow_date as 'Ngày mượn sách',
    br.return_date as 'Ngày trả sách'
    from
        BorrowingRecords br
    join
    Books b on br.book_id = b.book_id
    join
    Readers r on br.reader_id = r.id
    where r.name = 'Nguyen Van A';


-- 3.Đếm số lần một cuốn sách đã được mượn
select
    b.book_title as 'Tên sách',
    count(*) as 'Số lần mượn'
from 
    Books b
join
    BorrowingRecords br on b.book_id = br.book_id
group by b.book_title;


-- 4.Truy vấn tên của độc giả đã mượn nhiều sách nhất
select
    r.name as 'Tên độc giả',
    count(*) as 'Số sách đã mượn'
from 
    Readers r
join
    BorrowingRecords br on r.id = br.reader_id
group by r.name
order by count(*) desc
limit 1;

-- ---------------YÊU CẦU 2---------------

-- 1.Tạo view tên là borrowes_books để hiển thị thông tin sách đã mượn
-- bao gồm tên sách, tên độc giả, và ngày mượn.Sử dụng bảng Books, Readers và BorrowingRecords
create view borrowes_books as
select
    b.book_title as 'Tên sách',
    r.name as 'Tên độc giả',
    br.borrow_date as 'Ngày mượn sách'
from
    BorrowingRecords br
join
    Books b on br.book_id = b.book_id
join
    Readers r on br.reader_id = r.id;


-- ---------------YÊU CẦU 3---------------

-- 1.Viết một thủ tục tên là get_books_borrowed_by_reader nhận tham số là reader_id
-- thủ tục này trả về danh sách mà độc giả đó đã mượn, bao gồm tên sách và ngày mượn
delimiter //
create procedure get_books_borrowed_by_reader(reader_id int)
begin
    select
        b.book_title as 'Tên sách',
        br.borrow_date as 'Ngày mượn sách'
    from
        BorrowingRecords br
    join
        Books b on br.book_id = b.book_id
    join
        Readers r on br.reader_id = r.id
        where r.id = reader_id;

end //
delimiter ;

-- ---------------YÊU CẦU 4---------------
-- 1.Tạo một trigger để tự động cập. nhật ngày trả sách trong bảng BorrowingRecords khi cuốn sách được trả
--được cập nhật với giá trị return_date,trigger sẽ ghi lại ngày trả sách nếu return_date chưa được điền trước đó
delimiter //
create trigger update_return_date
before update on BorrowingRecords
for each row
begin
	if NEW.return_date is null then
    set NEW.return_date = CURDATE();
    end if;
end //
delimiter ;