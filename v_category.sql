WITH
    recursive tree AS(
    SELECT
        -10 AS `CategoryId`,
        NULL AS `CategoryParent`,
        CAST(
            'XXXX' AS CHAR(100) CHARSET utf8mb4
        ) AS `CategoryName`,
        1 AS `LEVEL`,
        CAST(
            'root' AS CHAR(100) CHARSET utf8mb4
        ) AS `path`
    UNION ALL
SELECT
    `c2`.`CategoryId` AS `CategoryId`,
    IFNULL(`c2`.`CategoryParent`, -10) AS `IFNULL(c2.CategoryParent, -10)`,
    CAST(
        `c2`.`CategoryName` AS CHAR(100) CHARSET utf8mb4
    ) AS `CAST(c2.CategoryName AS VARCHAR(100))`,
    `tree`.`LEVEL` + 1 AS `LEVEL`,
    CAST(
        CONCAT(
            `tree`.`path`,
            '/',
            RIGHT(
                CONCAT(
                    '000000000',
                    CAST(
                        `c2`.`CategoryId` AS CHAR(100) CHARSET utf8mb4
                    )
                ),
                10
            )
        ) AS CHAR(100) CHARSET utf8mb4
    ) AS `Path`
FROM
    (
        `nette`.`category` `c2`
    JOIN `tree` ON
        (
            `tree`.`CategoryId` = IFNULL(`c2`.`CategoryParent`, -10)
        )
    )
)
SELECT
    `tree`.`path` AS `OrderPath`,
    `tree`.`CategoryId` AS `CategoryId`,
    `tree`.`LEVEL` - 1 AS `Level`,
    `a`.`CategoryName` AS `CategoryName`
FROM
    (
        `tree`
    LEFT JOIN `nette`.`category` `a`
    ON
        (`a`.`CategoryId` = `tree`.`CategoryId`)
    )
WHERE
    `tree`.`path` <> 'root'
ORDER BY
    `tree`.`path`
