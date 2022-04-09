create table board(
	bno number primary key,
	title varchar2(100) not null,
	name varchar2(20) not null,
	content clob not null,
	regdate date default sysdate,
	readcount number default 0,
	password varchar2(128) not null
);

create sequence board_no_seq;

create table tbl_reply(
	rno number(10, 0),
	bno number(10,0) not null,
	reply varchar2(1000) not null,
	replyDate date default sysdate,
	updateDate date default sysdate
);

create sequence seq_reply;

alter table tbl_reply add constraint pk_reply primary key (rno);

alter table tbl_reply add constraint fk_reply_board foreign key (bno) references board (bno);

create table tbl_attach (
	uuid varchar2(100) not null,
	uploadPath varchar2(200) not null,
	fileName varchar2(100) not null,
	filetype char(1) default 'I',
	bno number(10,0)
);

alter table tbl_attach add constraint pk_attach primary key (uuid);

alter table tbl_attach add constraint fk_boaard foreign key (bno) references board (bno);