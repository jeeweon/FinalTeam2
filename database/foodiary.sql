create sequence mem_seq;
create table mem (
         mem_no         number primary key ,
         mem_email         varchar2(60) unique not null check(regexp_like(mem_email,'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$')),
         mem_pw         varchar2(20) not null,
         mem_nick         varchar2(30) unique not null check(regexp_like(mem_nick, '^[가-힣][가-힣0-9]{0,9}$')),
         mem_intro         varchar2(300),
         mem_birth         varchar2(8) not null,
         mem_level         char(3) default 1 not null check(mem_level in(1,2,3,4,5,6,444)),
         mem_point         number default 0 not null check(mem_point>=0),
         mem_join_date date default sysdate not null,
         mem_login_date  date
);

alter table mem modify mem_intro varchar2(300) default null;

drop table drop_wait;
create sequence drop_wait_seq;
create table drop_wait (
          wait_no number primary key,
          wait_mem_no          number unique not null,
          wait_mem_email          varchar2(60) unique not null,
          wait_mem_pw          varchar2(20) not null,
          wait_mem_nick          varchar2(30) default null, -- 대기였던 동안 닉네임 누가 가져갈 수 있으니 닉네임은 null 처리
          wait_mem_intro         varchar2(300),
          wait_mem_birth          varchar2(8) not null,
          wait_mem_level          char(3) default 1 not null check(wait_mem_level in(1,2,3,4,5,6,444)),
          wait_mem_point          number not null,
          wait_mem_join_date          date not null,
          wait_mem_login_date date,
          wait_mem_drop_date date default sysdate not null
);

drop table self_check;
create table  self_check  (
         who         varchar2(60) primary key,
         serial         varchar2(6)         not null,
         when         date default sysdate
);

drop table level_point;
create table level_point (
         review_point         number not null,
         like_point         number not null
);

create sequence follow_seq;
create table follow (
         follow_no number primary key,
         active_mem_no  references mem(mem_no) on delete cascade,
         passive_mem_no references mem(mem_no) on delete cascade
);

create sequence review_seq;
CREATE TABLE review (
        review_no        number primary key,
        mem_no references mem(mem_no) on delete cascade,
        review_content varchar2(3000),
        review_write_time date default sysdate not null,
        star_score        number(2,1),
        review_place varchar2(120),
        review_report_cnt number default 0 not null check(review_report_cnt>=0)
);

create sequence mem_noti_seq;
create table  mem_noti  (
         noti_no  number primary key,
         caller_mem_no references mem(mem_no) on delete cascade,
         receiver_mem_no references mem(mem_no) on delete cascade,
         noti_content varchar2(300) not null,
         noti_type         varchar2(10) not null,
         noti_target         number not null,
         noti_url         varchar2(2000) not null,
         noti_create_date         date default sysdate not null,
         noti_isread  char(1) default 0 not null check(noti_isread in(0,1))
);

create sequence reply_seq;
create table reply(
        reply_no number primary key,
        review_no references review(review_no) on delete cascade,
        mem_no references mem(mem_no) on delete cascade,
        reply_content varchar2(3000) not null,
        reply_write_time date default sysdate not null,
        reply_report_cnt number default 0 not null check(reply_report_cnt>=0) 
);

CREATE TABLE likes ( --like가 예약어라 likes로 대체
        review_no references review(review_no) on delete cascade,
        mem_no references mem(mem_no) on delete cascade
);

CREATE TABLE bookmark (
        mem_no references mem(mem_no) on delete cascade,
        review_no references review(review_no) on delete cascade,
        bookmark_time date default sysdate not null
);

create sequence review_report_seq;
CREATE TABLE  review_report  (
         review_report_no  number primary key,
         review_no references review(review_no) on delete cascade,
         mem_no number not null,
         review_report_time date default sysdate not null
);

create sequence reply_report_seq;
CREATE TABLE  reply_report  (
         reply_report_no number primary key,
         reply_no  references reply(reply_no) on delete cascade,
         mem_no number not null,
         reply_report_time date default sysdate not null
);

create sequence review_blind_seq;
CREATE TABLE  review_blind  (
         review_blind_no number primary key,
         review_no         references review(review_no) on delete cascade,
         blind_report_cnt number default 0 not null check(blind_report_cnt>=0),
         review_isblind         char(1) default 0 not null check(review_isBlind in (0,1,2)),
         report_start_time date default sysdate,
         blind_clear_time date
);

create sequence reply_blind_seq;
CREATE TABLE  reply_blind  (
         reply_blind_no  number        primary key,
         reply_no references reply(reply_no) on delete cascade,
         blind_report_cnt number default 0 not null check(blind_report_cnt>=0),
         reply_isblind         char(1) not null check(reply_isBlind in (0,1,2)),
         report_start_time date default sysdate, 
         blind_clear_time date
);

create sequence attach_seq;
CREATE TABLE  attach  (
         attach_no         number        primary key,
         attach_name varchar2(256) not null,
         attach_type varchar2(30) not null,
         attach_size number not null check(attach_size>=0),
         attach_time date default sysdate not null
);

CREATE TABLE  profile_attach  (
         attach_no         references attach(attach_no) on delete cascade,
         mem_no references mem(mem_no) on delete cascade
);

CREATE TABLE  review_attach  (
         attach_no         references attach(attach_no) on delete cascade,
         review_no         references review(review_no) on delete cascade
);

create sequence admin_seq;
CREATE TABLE  admin  (
         admin_no number primary key,
         admin_id varchar2(20) unique not null, --admin1234(소문자, 숫자)
         admin_pw varchar2(20) not null, -- (영소문자, 숫자)
         admin_login_date date
);

create sequence notice_email_seq;
CREATE TABLE notice_email  (
         email_no number primary key,
         email_subject         varchar2(150) not null,
         email_content         varchar2(3000) not null,
         email_when date default sysdate
);

create sequence areas_seq;
CREATE TABLE  areas  (
         area_no number primary key,
         area_city varchar2(30) not null,
         area_district varchar2(30),
         area_nearby1 varchar2(30),
         area_nearby2 varchar2(30)
);

CREATE TABLE  interest_areas  (
         area_no references areas(area_no) on delete cascade,
         mem_no  references mem(mem_no) on delete cascade
);
commit;
