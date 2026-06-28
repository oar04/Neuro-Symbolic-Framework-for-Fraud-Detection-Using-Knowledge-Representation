// ============================================================
// create_graph.cypher
// Create transaction-entity graph for IEEE-CIS fraud dataset
// ============================================================

// Expected CSV location:
// Neo4j import directory:
//   import/neo4j_transactions.csv
//
// Expected key columns:
//   TransactionID
//   card1, card2, card3, card4, card5, card6
//   addr1, addr2
//   P_emaildomain, R_emaildomain
//   DeviceType, DeviceInfo
//   id_30, id_31


// -------------------------
// Constraints
// -------------------------

CREATE CONSTRAINT transaction_id_unique IF NOT EXISTS
FOR (t:Transaction)
REQUIRE t.transaction_id IS UNIQUE;

CREATE CONSTRAINT card_id_unique IF NOT EXISTS
FOR (c:Card)
REQUIRE c.card_id IS UNIQUE;

CREATE CONSTRAINT address_id_unique IF NOT EXISTS
FOR (a:Address)
REQUIRE a.address_id IS UNIQUE;

CREATE CONSTRAINT email_domain_unique IF NOT EXISTS
FOR (e:EmailDomain)
REQUIRE e.email_domain IS UNIQUE;

CREATE CONSTRAINT device_id_unique IF NOT EXISTS
FOR (d:Device)
REQUIRE d.device_id IS UNIQUE;

CREATE CONSTRAINT browser_id_unique IF NOT EXISTS
FOR (b:Browser)
REQUIRE b.browser_id IS UNIQUE;

CREATE CONSTRAINT os_id_unique IF NOT EXISTS
FOR (o:OperatingSystem)
REQUIRE o.os_id IS UNIQUE;


// -------------------------
// Load transactions
// -------------------------

LOAD CSV WITH HEADERS FROM 'file:///neo4j_transactions.csv' AS row
WITH row
WHERE row.TransactionID IS NOT NULL AND trim(row.TransactionID) <> ''

MERGE (t:Transaction {transaction_id: toString(row.TransactionID)})
SET
    t.transaction_amt = CASE
        WHEN row.TransactionAmt IS NULL OR trim(row.TransactionAmt) = ''
        THEN NULL
        ELSE toFloat(row.TransactionAmt)
    END,
    t.transaction_dt = CASE
        WHEN row.TransactionDT IS NULL OR trim(row.TransactionDT) = ''
        THEN NULL
        ELSE toInteger(row.TransactionDT)
    END;


// -------------------------
// Card entities
// -------------------------

LOAD CSV WITH HEADERS FROM 'file:///neo4j_transactions.csv' AS row
WITH row
MATCH (t:Transaction {transaction_id: toString(row.TransactionID)})

FOREACH (_ IN CASE WHEN row.card1 IS NOT NULL AND trim(row.card1) <> '' THEN [1] ELSE [] END |
    MERGE (c:Card {card_id: 'card1_' + toString(row.card1)})
    SET c.card_type = 'card1'
    MERGE (t)-[:USES]->(c)
)

FOREACH (_ IN CASE WHEN row.card2 IS NOT NULL AND trim(row.card2) <> '' THEN [1] ELSE [] END |
    MERGE (c:Card {card_id: 'card2_' + toString(row.card2)})
    SET c.card_type = 'card2'
    MERGE (t)-[:USES]->(c)
)

FOREACH (_ IN CASE WHEN row.card3 IS NOT NULL AND trim(row.card3) <> '' THEN [1] ELSE [] END |
    MERGE (c:Card {card_id: 'card3_' + toString(row.card3)})
    SET c.card_type = 'card3'
    MERGE (t)-[:USES]->(c)
)

FOREACH (_ IN CASE WHEN row.card4 IS NOT NULL AND trim(row.card4) <> '' THEN [1] ELSE [] END |
    MERGE (c:Card {card_id: 'card4_' + toString(row.card4)})
    SET c.card_type = 'card4'
    MERGE (t)-[:USES]->(c)
)

FOREACH (_ IN CASE WHEN row.card5 IS NOT NULL AND trim(row.card5) <> '' THEN [1] ELSE [] END |
    MERGE (c:Card {card_id: 'card5_' + toString(row.card5)})
    SET c.card_type = 'card5'
    MERGE (t)-[:USES]->(c)
)

FOREACH (_ IN CASE WHEN row.card6 IS NOT NULL AND trim(row.card6) <> '' THEN [1] ELSE [] END |
    MERGE (c:Card {card_id: 'card6_' + toString(row.card6)})
    SET c.card_type = 'card6'
    MERGE (t)-[:USES]->(c)
);


// -------------------------
// Address entities
// -------------------------

LOAD CSV WITH HEADERS FROM 'file:///neo4j_transactions.csv' AS row
WITH row
MATCH (t:Transaction {transaction_id: toString(row.TransactionID)})

FOREACH (_ IN CASE WHEN row.addr1 IS NOT NULL AND trim(row.addr1) <> '' THEN [1] ELSE [] END |
    MERGE (a:Address {address_id: 'addr1_' + toString(row.addr1)})
    SET a.address_type = 'addr1'
    MERGE (t)-[:USES]->(a)
)

FOREACH (_ IN CASE WHEN row.addr2 IS NOT NULL AND trim(row.addr2) <> '' THEN [1] ELSE [] END |
    MERGE (a:Address {address_id: 'addr2_' + toString(row.addr2)})
    SET a.address_type = 'addr2'
    MERGE (t)-[:USES]->(a)
);


// -------------------------
// Email domain entities
// -------------------------

LOAD CSV WITH HEADERS FROM 'file:///neo4j_transactions.csv' AS row
WITH row
MATCH (t:Transaction {transaction_id: toString(row.TransactionID)})

FOREACH (_ IN CASE WHEN row.P_emaildomain IS NOT NULL AND trim(row.P_emaildomain) <> '' THEN [1] ELSE [] END |
    MERGE (e:EmailDomain {email_domain: 'P_' + toString(row.P_emaildomain)})
    SET e.email_type = 'P_emaildomain'
    MERGE (t)-[:USES]->(e)
)

FOREACH (_ IN CASE WHEN row.R_emaildomain IS NOT NULL AND trim(row.R_emaildomain) <> '' THEN [1] ELSE [] END |
    MERGE (e:EmailDomain {email_domain: 'R_' + toString(row.R_emaildomain)})
    SET e.email_type = 'R_emaildomain'
    MERGE (t)-[:USES]->(e)
);


// -------------------------
// Device entities
// -------------------------

LOAD CSV WITH HEADERS FROM 'file:///neo4j_transactions.csv' AS row
WITH row
MATCH (t:Transaction {transaction_id: toString(row.TransactionID)})

FOREACH (_ IN CASE WHEN row.DeviceType IS NOT NULL AND trim(row.DeviceType) <> '' THEN [1] ELSE [] END |
    MERGE (d:Device {device_id: 'DeviceType_' + toString(row.DeviceType)})
    SET d.device_type = 'DeviceType'
    MERGE (t)-[:USES]->(d)
)

FOREACH (_ IN CASE WHEN row.DeviceInfo IS NOT NULL AND trim(row.DeviceInfo) <> '' THEN [1] ELSE [] END |
    MERGE (d:Device {device_id: 'DeviceInfo_' + toString(row.DeviceInfo)})
    SET d.device_type = 'DeviceInfo'
    MERGE (t)-[:USES]->(d)
);


// -------------------------
// Operating system and browser entities
// -------------------------

LOAD CSV WITH HEADERS FROM 'file:///neo4j_transactions.csv' AS row
WITH row
MATCH (t:Transaction {transaction_id: toString(row.TransactionID)})

FOREACH (_ IN CASE WHEN row.id_30 IS NOT NULL AND trim(row.id_30) <> '' THEN [1] ELSE [] END |
    MERGE (o:OperatingSystem {os_id: toString(row.id_30)})
    MERGE (t)-[:USES]->(o)
)

FOREACH (_ IN CASE WHEN row.id_31 IS NOT NULL AND trim(row.id_31) <> '' THEN [1] ELSE [] END |
    MERGE (b:Browser {browser_id: toString(row.id_31)})
    MERGE (t)-[:USES]->(b)
);


// -------------------------
// Sanity checks
// -------------------------

MATCH (t:Transaction)
RETURN 'Transactions' AS node_type, count(t) AS count
UNION
MATCH (c:Card)
RETURN 'Cards' AS node_type, count(c) AS count
UNION
MATCH (a:Address)
RETURN 'Addresses' AS node_type, count(a) AS count
UNION
MATCH (e:EmailDomain)
RETURN 'EmailDomains' AS node_type, count(e) AS count
UNION
MATCH (d:Device)
RETURN 'Devices' AS node_type, count(d) AS count
UNION
MATCH (b:Browser)
RETURN 'Browsers' AS node_type, count(b) AS count
UNION
MATCH (o:OperatingSystem)
RETURN 'OperatingSystems' AS node_type, count(o) AS count;
