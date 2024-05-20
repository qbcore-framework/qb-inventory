INSERT INTO inventories (identifier, items)
SELECT
  CONCAT('glovebox-', plate),
  items
FROM
  gloveboxitems

UNION ALL

SELECT
  stash,
  items
FROM
  stashitems

UNION ALL

SELECT
  CONCAT('trunk-', plate),
  items
FROM
  trunkitems;