USE pbm;
#Part 2) Primary and Foreign Key Setup in MySQL

############################################ drugcode ###########################################

#Making sure that PK is VARCAR
ALTER TABLE drugcode
MODIFY drug_brand_generic_code VARCHAR(255);

#Making primary key
ALTER TABLE drugcode
ADD PRIMARY KEY (drug_brand_generic_code);

############################################ druginfo ##########################################

ALTER TABLE druginfo
MODIFY drug_ndc VARCHAR(255);

ALTER TABLE druginfo
ADD PRIMARY KEY (drug_ndc);

#Assigning Foreign key

#Making sure that FK is VARCAR
ALTER TABLE druginfo
MODIFY drug_brand_generic_code VARCHAR(255);

#Making Foreign key

ALTER TABLE druginfo
ADD FOREIGN KEY (drug_brand_generic_code) REFERENCES pbm.drugcode(drug_brand_generic_code)
ON DELETE SET NULL
ON UPDATE RESTRICT;
######################################## members ###############################################

ALTER TABLE members
MODIFY member_id VARCHAR(255);

ALTER TABLE members
ADD PRIMARY KEY (member_id);

############################################ copay data ###########################################
#Creating Unique id for copay
#making it Primary key

ALTER TABLE copay
ADD transation_id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE pbm.copay
MODIFY drug_ndc VARCHAR(255);

ALTER TABLE pbm.copay
ADD FOREIGN KEY (drug_ndc) REFERENCES pbm.druginfo(drug_ndc)
ON DELETE SET NULL
ON UPDATE RESTRICT;

#Checking tables
SELECT * FROM druginfo;
SELECT * FROM drugcode;
SELECT * FROM members;
SELECT * FROM copay;
###############################################################################################
#Part 4) Analytics and Reporting

#Part A
SELECT COUNT(transation_id) as prescriptions, d.drug_name
FROM copay c
LEFT JOIN druginfo d on c.drug_ndc = d.drug_ndc
GROUP BY drug_name; 


#Part B

SELECT COUNT(transation_id) as prescriptions, count(distinct(m.member_id)) as members,
CASE 
WHEN m.member_age >= '65' THEN '65+'
WHEN m.member_age < '65' THEN 'upto 65'
END as age_group , SUM(copay_amount) as copay_paid, SUM(insurance_amount) as insurance_paid
FROM copay c
LEFT JOIN members m on c.member_id = m.member_id
GROUP BY age_group;

#Part 3
SELECT m.member_id, member_first_name, member_last_name, c.insurance_amount as most_recent_insurance_paid,
c.fill_date as Last_payment_date
FROM members m  left join (select Max(c.fill_date) as fd,m.member_id from members m JOIN copay c on c.member_id = m.member_id  group by m.member_id) a on m.member_id = a.member_id 
JOIN copay c on c.member_id = m.member_id where c.fill_date = a.fd



