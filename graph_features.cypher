// ============================================================
// graph_features.cypher
// Compute structural graph features using Neo4j GDS
// ============================================================



CALL gds.graph.list()
YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;


// -------------------------
// If a previous projection exists, drop it manually if needed:
// -------------------------
//
// CALL gds.graph.drop('fraud_graph');


// -------------------------
// Project transaction-entity graph
// -------------------------

CALL gds.graph.project(
    'fraud_graph',
    [
        'Transaction',
        'Card',
        'Address',
        'EmailDomain',
        'Device',
        'Browser',
        'OperatingSystem'
    ],
    {
        USES: {
            orientation: 'UNDIRECTED'
        }
    }
)
YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;


// -------------------------
// Degree centrality
// -------------------------

CALL gds.degree.write(
    'fraud_graph',
    {
        writeProperty: 'degree'
    }
)
YIELD nodePropertiesWritten, centralityDistribution
RETURN nodePropertiesWritten, centralityDistribution;


// -------------------------
// PageRank
// -------------------------

CALL gds.pageRank.write(
    'fraud_graph',
    {
        writeProperty: 'pagerank',
        maxIterations: 20,
        dampingFactor: 0.85
    }
)
YIELD nodePropertiesWritten, ranIterations
RETURN nodePropertiesWritten, ranIterations;


// -------------------------
// Louvain community detection
// -------------------------

CALL gds.louvain.write(
    'fraud_graph',
    {
        writeProperty: 'communityId'
    }
)
YIELD communityCount, modularity, modularities
RETURN communityCount, modularity, modularities;


// -------------------------
// Sanity check transaction features
// -------------------------

MATCH (t:Transaction)
RETURN
    count(t) AS transaction_count,
    count(t.degree) AS degree_count,
    count(t.pagerank) AS pagerank_count,
    count(t.communityId) AS community_count;


// -------------------------
// Preview exported features
// -------------------------

MATCH (t:Transaction)
RETURN
    t.transaction_id AS TransactionID,
    t.communityId AS community_id,
    t.pagerank AS pagerank,
    t.degree AS degree
LIMIT 20;
