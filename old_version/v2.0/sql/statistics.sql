/*전 수강과목 수강인원수 일람*/
SELECT AVG(cnt) FROM
(
	SELECT C.code, C.divide, count(*) cnt
	FROM htt_table_code C,
		(SELECT max(uid) uid FROM htt_table GROUP BY id) MX
	WHERE C.uid = MX.uid
	GROUP BY C.code, C.divide
) MEAN;


/*해당 과목 포화도 예측*/
SELECT C.code, C.divide,
	count(*) / 
	(
		SELECT AVG(cnt) FROM
		(
			SELECT C.code, C.divide, count(*) cnt
			FROM htt_table_code C,
				(SELECT max(uid) uid FROM htt_table GROUP BY id) MX
			WHERE C.uid = MX.uid
			GROUP BY C.code, C.divide
		) MEAN
	) saturation
FROM htt_table_code C,
	(SELECT max(uid) uid FROM htt_table GROUP BY id) MX
WHERE C.uid = MX.uid
GROUP BY C.code, C.divide;


/*사용자 신청과목별 경합수 및 포화도 예측*/
SELECT SUB.code, SUB.divide, count(*), STA.saturation
FROM
	htt_table_code SUB INNER JOIN
	(
		SELECT id, max(uid) uid FROM htt_table
		GROUP BY id
	) IND ON SUB.uid = IND.uid INNER JOIN
	htt_member MEM ON IND.id = MEM.id INNER JOIN
	(
		SELECT C.code, C.divide,
			count(*) / 
			(
				SELECT AVG(cnt) FROM
				(
					SELECT C.code, C.divide, count(*) cnt
					FROM htt_table_code C,
						(SELECT max(uid) uid FROM htt_table GROUP BY id) MX
					WHERE C.uid = MX.uid
					GROUP BY C.code, C.divide
				) MEAN
			) saturation
		FROM htt_table_code C,
			(SELECT max(uid) uid FROM htt_table GROUP BY id) MX
		WHERE C.uid = MX.uid
		GROUP BY C.code, C.divide
	) STA ON (STA.code = SUB.code AND STA.divide = SUB.divide)
WHERE 
	(SUB.code, SUB.divide) IN
	(
		SELECT code, divide
		FROM htt_table_code
		WHERE uid = 
			(
				SELECT max(uid)
				FROM htt_table
				WHERE id = ?
			)
	) AND IND.id <> ?
GROUP BY SUB.code, SUB.divide;


/*
	아직 표본 수가 적어서 학과별, 학년별 포화도 예측은 힘들다
	작성 시점 현재 표본수 약 500개
*/