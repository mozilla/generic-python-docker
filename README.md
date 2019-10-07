[![CircleCI](https://circleci.com/gh/mozilla/mozilla-schema-generator/tree/master.svg?style=svg)](https://circleci.com/gh/mozilla/mozilla-schema-generator/tree/master)

# Mozilla Schema Generator

A library for generating full representations of Mozilla telemetry pings.

See [Mozilla Pipeline Schemas](https://www.github.com/mozilla-services/mozilla-pipeline-services)
for the more generic structure of pings. This library takes those generic structures and fills in
all of the probes we expect to see in the appropriate places.

## Telemetry Integration

There are two pings we are targeting for integration with this library:

1. [The Main Ping](http://gecko-docs.mozilla.org.s3.amazonaws.com/toolkit/components/telemetry/telemetry/data/main-ping.html)
   is the historical Firefox Desktop ping, and contains many more than ten-thousand total pieces of data.
2. [The Glean Ping](https://github.com/mozilla/glean_parser) is the new ping-type being created for
   more generic data collection.

This library takes the information for what should be in those pings from the [Probe Info Service](https://www.github.com/mozilla/probe-scraper).

## Data Store Integration

The primary use of the schemas is for integration with the
[Schema Transpiler](https://www.github.com/mozilla/jsonschema-transpiler). 
The schemas that this repository generates can be transpiled into Avro and Bigquery. They define
the schema of the Avro and BigQuery tables that the [BQ Sink](https://www.github.com/mozilla/gcp-ingestion)
writes to.

### BigQuery Limitations and Splitting

BigQuery has a hard limit of ten thousand columns on any single table. This library
can take that limitation into account by splitting schemas into multiple tables. Each
table has some common information that are duplicated in every table, and then a set
of fields that are unique to that table. The join of these tables gives the full
set of fields available from the ping.

To decide on a table split, we include the `table_group` configuration in the configuration
file. For example, `payload/histograms` has `table_group: histograms`; this indicates that
there will be a table outputted with just histograms.

Currently, generates tables for:
- Histograms
- Keyed Histograms
- Scalars
- Keyed Scalars
- Everything else

If a single table expands beyond 9000 columns, we move the new fields to the next table.
For example, main_histograms_1 and main_histograms_2.

Note: Tables are only split if the `--split` parameter is provided.

## Validation

A secondary use-case of these schemas is for validation. The schemas produced are guaranteed to
be more correct, since they include explicit definitions of every metric and probe.

## Usage

### Main Ping

Generate the Full Main Ping schema:

```
mozilla-schema-generator generate-main-ping
```

Generate the Main Ping schema divided among tables (for BigQuery):
```
mozilla-schema-generator generate-main-ping --split --out-dir main-ping
```

The `out-dir` parameter will be the namespace for the pings.

To see a full list of options, run `mozilla-schema-generator generate-main-ping --help`.


### Glean

Generate all Glean ping schemas - one for each application, for each ping
that application sends:

```
mozilla-schema-generator generate-glean-pings
```

Write schemas to a directory:
```
mozilla-schema-generator generate-glean-pings --out-dir glean-ping
```

To see a full list of options, run `mozilla-schema-generator generate-glean-pings --help`.


## Configuration Files

Configuration files are default found in `/config`. You can also specify your own when running the generator.

Configuration files match certain parts of a ping to certain types of probes or metrics. The nesting
of the config file matches the ping it is filling in. For example, Glean stores probe types under
the `metrics` key, so the nesting looks like this:
```
{
    "metrics": {
        "string": {
            <METRIC_ID>: {...}
        }
    }
}
```

While the generic schema doesn't include information about the specific `<METRIC_ID>`s being included,
the schema-generator does. To include the correct metrics that we would find in that section of the ping,
we would organize the `config.yaml` file like this:

```
metrics:
    string:
        match:
            type: string
```

The `match` key indicates that we should fill-in this section of the ping schema with metrics,
and the `type: string` makes sure we only put string metrics in there. You can do an exact
match on any field available in the ping info from the [probe-info-service](https://probeinfo.telemetry.mozilla.org/glean/glean/metrics),
which also contains the [Desktop probes](https://probeinfo.telemetry.mozilla.org/firefox/all/main/all_probes).

There are a few additional keywords allowable under any field:
* `contains` - e.g. `process: contains: main`, indicates that the `process` field is an array
  and it should only match those that include the entry `main`.
* `not` - e.g. `send_in_pings: not: glean_ping_info`, indicates that we should match
  any field for `send_in_pings` _except_ `glean_ping_info`.

### `table_group` Key

This specific field is for indicating which table group that section of the ping should be included in when
splitting the schema. Currently we do not split the Glean ping, only the Main. See the section on [BigQuery
Limitations and Splitting](#bigquery-limitations-and-splitting) for more info.

## Development and Testing

Install requirements:
```
make install-requirements
```

Run tests:
```
make test
```
