-- 开启 mini-batch
SET table.exec.mini-batch.enabled=true;
-- mini-batch的时间间隔，即作业需要额外忍受的延迟
SET table.exec.mini-batch.allow-latency=1s;
-- 一个 mini-batch 中允许最多缓存的数据
SET table.exec.mini-batch.size=1000;
-- 开启 local-global 优化
SET table.optimizer.agg-phase-strategy=TWO_PHASE;

-- 开启 distinct agg 切分
SET table.optimizer.distinct-agg.split.enabled=true;


-- source
-- CREATE TABLE user_log (
--     user_id VARCHAR,
--     item_id VARCHAR,
--     category_id VARCHAR,
--     behavior VARCHAR,
--     ts TIMESTAMP
-- ) WITH (
--     'type' = 'kafka',
--     'topic' = 'user_behavior',
--     'startup-mode' = 'earliest-offset',
--     'format.type' = 'json',
-- );
--
-- -- sink
-- CREATE TABLE pvuv_sink (
--     dt VARCHAR,
--     pv BIGINT,
--     uv BIGINT
-- ) WITH (
--     'connector.type' = 'jdbc',
--     'connector.url' = 'jdbc:mysql://localhost:3306/flink-test',
--     'connector.table' = 'pvuv_sink',
--     'connector.username' = 'root',
--     'connector.password' = '123456',
--     'connector.write.flush.max-rows' = '1'
-- );
--
--
-- INSERT INTO pvuv_sink
-- SELECT
--   DATE_FORMAT(ts, 'yyyy-MM-dd HH:00') dt,
--   COUNT(*) AS pv,
--   COUNT(DISTINCT user_id) AS uv
-- FROM user_log
-- GROUP BY DATE_FORMAT(ts, 'yyyy-MM-dd HH:00');