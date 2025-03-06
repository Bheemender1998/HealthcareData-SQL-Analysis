-- Total number of patients
select count(*) as total_patients
  from hc_data;

-- Gender distribution of patients
select gender,
       count(*) as total_patients
  from hc_data
 group by gender
 order by total_patients desc;

-- Age distribution of patients
select case
   when age < 18              then
      'Pediatric'
   when age between 18 and 64 then
      'Adult'
   else
      'Senior'
       end as age_group,
       count(*) as total_patients
  from hc_data
 group by
   case
      when age < 18              then
         'Pediatric'
      when age between 18 and 64 then
         'Adult'
      else
         'Senior'
   end
 order by total_patients desc;

-- Most common medical conditions
select medical_condition,
       count(*) as occurrences
  from hc_data
 group by medical_condition
 order by occurrences desc
 fetch first 5 rows only;

-- Most common admission type
select admission_type,
       count(*) as count
  from hc_data
 group by admission_type
 order by count desc;

-- Average billing amount per admission type
select admission_type,
       round(
          avg(billing_amount),
          2
       ) as avg_billing
  from hc_data
 group by admission_type
 order by avg_billing desc;

-- Top insurance provider by patient coverage
select insurance_provider,
       count(*) as total_patients
  from hc_data
 group by insurance_provider
 order by total_patients desc
 fetch first 1 row only;

-- Average billing amount per insurance provider
select insurance_provider,
       round(
          avg(billing_amount),
          2
       ) as avg_billing
  from hc_data
 group by insurance_provider
 order by avg_billing desc;

-- Admission types generating the highest total revenue
select admission_type,
       sum(billing_amount) as total_revenue
  from hc_data
 group by admission_type
 order by total_revenue desc;

-- Age group contributing most to hospital revenue
select case
   when age < 18              then
      'Pediatric'
   when age between 18 and 64 then
      'Adult'
   else
      'Senior'
       end as age_group,
       sum(billing_amount) as total_revenue
  from hc_data
 group by
   case
      when age < 18              then
         'Pediatric'
      when age between 18 and 64 then
         'Adult'
      else
         'Senior'
   end
 order by total_revenue desc;

-- Patients who visited multiple hospitals
select name,
       count(distinct hospital) as hospital_visits
  from hc_data
 group by name
having count(distinct hospital) > 1
 order by hospital_visits desc;

-- Most prescribed medications for high-billing cases
select medication,
       count(*) as prescription_count,
       round(
          avg(billing_amount),
          2
       ) as avg_cost
  from hc_data
 group by medication
 order by avg_cost desc
 fetch first 5 rows only;

-- Doctor with the highest patient readmission rate
select a.doctor,
       count(distinct a.name) as readmission_count
  from hc_data a
  join hc_data b
on a.name = b.name
   and b.date_of_admission > a.discharge_date
   and b.date_of_admission - a.discharge_date <= 30
 group by a.doctor
 order by readmission_count desc
 fetch first 5 rows only;

-- Average doctor workload per month
select doctor,
       extract(month from date_of_admission) as month,
       count(*) as patients_treated
  from hc_data
 group by doctor,
          extract(month from date_of_admission)
 order by month desc,
          patients_treated desc;

-- Hospitals with highest average billing per patient
select hospital,
       round(
          avg(billing_amount),
          2
       ) as avg_billing
  from hc_data
 group by hospital
 order by avg_billing desc
 fetch first 5 rows only;

-- Most expensive medical conditions on average
select medical_condition,
       round(
          avg(billing_amount),
          2
       ) as avg_cost,
       max(billing_amount) as max_cost
  from hc_data
 group by medical_condition
 order by avg_cost desc
 fetch first 5 rows only;

-- Hospitals generating the highest total revenue
select hospital,
       sum(billing_amount) as total_revenue
  from hc_data
 group by hospital
 order by total_revenue desc
 fetch first 5 rows only;

-- Highest readmission rate per hospital
select a.hospital,
       count(distinct a.name) as readmission_count
  from hc_data a
  join hc_data b
on a.name = b.name
   and b.date_of_admission > a.discharge_date
   and b.date_of_admission - a.discharge_date <= 30
 group by a.hospital
 order by readmission_count desc
 fetch first 5 rows only;