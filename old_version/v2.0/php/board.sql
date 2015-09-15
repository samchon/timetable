CREATE TABLE board (
	uid int(10) NOT NULL auto_increment,
	fid int(10) NOT NULL default '0',
	sort varchar(30) NOT NULL default '',
	isSurvive bigint(1) NOT NULL default '0',
	id varchar(10) NOT NULL default '',
	subject varchar(60) NOT NULL default '',
	memo text NOT NULL,
	ip varchar(15) NOT NULL default '',
	timestamp varbinary(19) default NULL,
	hit int(10) NOT NULL default '0',
	depth varchar(4) NOT NULL default '',

	PRIMARY KEY(uid)
)