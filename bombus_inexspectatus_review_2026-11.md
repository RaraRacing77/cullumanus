# Bombus inexspectatus Workflow Review

*Last updated: November 2026*

## Purpose

This document captures the original workflow developed to identify potential georeferencing issues in biodiversity records of *Bombus inexspectatus*.

The goal was not to prove that records were incorrect, but to identify observations where the reported coordinates appeared inconsistent with the stated collecting locality.

---

## Background

During an analysis of GBIF occurrence records for *Bombus inexspectatus*, several records were identified whose coordinates appeared to be significantly displaced from the locality names associated with the observations.

Because *Bombus inexspectatus* is a montane species, a number of these records immediately stood out. Many referenced well-known mountain passes in northern Spain, yet their coordinates appeared tens of kilometers away from those locations.

This led to the development of a validation workflow based on a manually curated gazetteer.

---

# Workflow

## 1. Data Sources

### GBIF

Raw download:

```text
occurrence.txt
```

Processed using:

```text
clean_species.R
```

Output:

```text
bombus_inexspectatus_spain_clean.csv
```

---

### Atlas Hymenoptera

Source file:

```text
bombus_inexspectatus.csv
```

Processed using:

```text
clean_atlas.R
```

Output:

```text
bombus_inexspectatus_atlas_clean.csv
```

---

## 2. Data Integration

Both cleaned datasets are merged into a single dataset:

```r
combined <- bind_rows(gbif_df, atlas_clean)
```

Output:

```text
bombus_inexspectatus_combined.csv
```

---

## 3. Gazetteer Validation

A custom gazetteer was created containing reference coordinates for known mountain passes and collecting localities.

Examples include:

- Puerto de Ranadoiro
- Puerto de Tarna
- Puerto de San Glorio
- Puerto de las Señales
- Puerto de Pajares
- Puerto de Leitariegos
- Puerto el Palo

Each observation was compared against the corresponding gazetteer entry.

The distance between:

- the coordinates attached to the biodiversity record; and
- the reference coordinates in the gazetteer

was calculated using:

```r
geosphere::distHaversine()
```

---

## 4. Identification of Contentious Records

Records were flagged as potentially problematic when:

```r
distance_to_ref > 10
```

Output:

```text
contentious_records.csv
```

---

# Results

## Flagged Records

The workflow identified seven records with discrepancies greater than 10 km.

### Puerto de Ranadoiro

| Year | Distance |
|--------|---------:|
| 1968 | 32.8 km |
| 1968 | 32.8 km |
| Unknown | 25.1 km |

### Puerto de las Señales

| Year | Distance |
|--------|---------:|
| Unknown | 22.1 km |

### Puerto el Palo

| Year | Distance |
|--------|---------:|
| 1988 | 46.5 km |
| 1988 | 39.1 km |
| 1988 | 39.1 km |

The discrepancies are substantial and cannot reasonably be explained by normal GPS uncertainty.

---

# Interpretation

## Working Hypothesis

The most likely explanation is that the error was introduced during a later digitization or georeferencing stage rather than during the original field collection.

A plausible scenario is:

1. A collector records only a locality name.
2. The specimen or observation is digitized years later.
3. Coordinates are added retrospectively.
4. The locality name is searched in a mapping application.
5. Coordinates from a nearby village, settlement, or similarly named geographic feature are selected.
6. These coordinates become associated with the record.
7. The record is subsequently shared through biodiversity databases, including GBIF.

This would explain discrepancies of 20-50 km while preserving locality names that remain ecologically plausible for the species.

---

# Case Study: Puerto de Ranadoiro

Puerto de Ranadoiro provides a particularly interesting example.

The locality name most likely refers to the historic mountain pass (*Alto de Ranadoiro*) in Asturias.

This location represents suitable habitat for a montane species such as *Bombus inexspectatus*.

Today, traffic passes through a tunnel beneath the pass, while the original mountain road remains visible but is largely abandoned.

The records investigated appear to be associated with coordinates that do not correspond to the mountain pass itself, suggesting a possible georeferencing error involving another geographic feature linked to the same name.

This supports the digitization-error hypothesis.

---

# Limitations

A major limitation of the investigation was the lack of complete provenance information.

Several records referenced sources such as:

```text
54_Wood_etal_7103_Yarrow 1970
54_Wood_etal_7104_Yarrow 1970
54_Wood_etal_35219_Obeso 1992
54_Wood_etal_35220_Obeso 1992
54_Wood_etal_35221_Obeso 1992
```

It was not possible to determine with confidence whether these references correspond to:

- museum specimens;
- collection records;
- scientific publications;
- database identifiers; or
- another source type.

As a result, it was impossible to establish:

- when coordinates were assigned;
- who performed the georeferencing;
- what methodology was used;
- where the discrepancy was introduced.

---

# Key Finding

The most important conclusion is not that the coordinates are definitively incorrect.

The most important conclusion is:

> The reported coordinates appear inconsistent with the stated localities, while the original source material cannot currently be traced sufficiently to determine when or how the discrepancy was introduced.

The problem is therefore fundamentally one of:

- data quality;
- provenance;
- traceability;
- biodiversity informatics.

---

# Future Actions

## Technical

- Re-run the original workflow.
- Review gazetteer matching logic.
- Compare matching using `locality` versus `locality_norm`.
- Revalidate all flagged records.

## Research

- Attempt to locate the original references.
- Investigate whether publications by Wood, Yarrow, and Obeso can be identified.
- Determine whether specimen labels or collection records are available.

## Blog

- Revisit the draft article.
- Update the analysis where necessary.
- Reframe the article around biodiversity data quality and provenance.
- Highlight the challenges of georeferencing historical biodiversity records.

---

# Reflection

This investigation began as a study of a rare bumblebee species.

Over time, the focus shifted toward a broader question: how reliable and traceable are biodiversity records once they have passed through multiple stages of digitization and aggregation?

The resulting workflow provides a reusable framework for investigating:

- bumblebee records;
- butterfly records;
- odonate records;
- biodiversity data from Cantabria;
- future biodiversity informatics projects;
- potential RBINS-related data quality investigations.

The project ultimately became less about *Bombus inexspectatus* itself and more about understanding how biodiversity data can lose context as it moves through the data lifecycle.
