SELECT "friend_id" FROM "friends"
JOIN "users" ON "friends"."user_id" = "users"."id"
WHERE "users"."username" = 'lovelytrust487'
INTERSECT
SELECT "friend_id" FROM "friends"
JOIN "users" ON "friends"."user_id" = "users"."id"
WHERE "users"."username" = 'exceptionalinspiration482';