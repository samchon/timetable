CREATE TABLE hansung_board_delete(
 uid int(10) NOT NULL auto_increment,
 fid int(10) NOT NULL,
 sort varchar(30) NOT NULL,
 id varchar(10) NOT NULL,
 writer varchar(20) NOT NULL,
 subject varchar(60) NOT NULL,
 memo text NOT NULL,
 ip varchar(15) NOT NULL,
 date varchar(12) NOT NULL,
 hit int(10) NOT NULL,
 depth varchar(4) NOT NULL,
 PRIMARY KEY(uid),
 KEY fid(fid),
 KEY sort(sort)
)