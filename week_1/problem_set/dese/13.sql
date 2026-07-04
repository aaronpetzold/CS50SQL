SELECT "districts"."city", "staff_evaluations"."unsatisfactory" FROM "districts"
JOIN "staff_evaluations" ON "districts"."id" = "staff_evaluations"."district_id"
ORDER BY "staff_evaluations"."unsatisfactory" DESC
LIMIT 10;