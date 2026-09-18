# Cleaning and imputation

[Manuscript guide](../README.md) · [Collection](sampling-and-collection.md) · [Signals](../methods/engagement-signals-and-changepoints.md)

## News deduplication and exclusions

Appendix B.1 reports an initial **5,266,854 Sotrender posts** and **646,133
Content Library posts**. It describes an index combining lowercased post text
with non-alphanumeric characters removed, timestamp and source. This identified
**132,090 cross-source duplicates**. Sotrender records were preferred because
they constituted most of the data and Content Library observations often lacked
reactions or comments. Source: Appendix B.1,
[p. 17](../../manuscript/manuscript.pdf#page=17).

| Reported cleaning item | Count or description |
|---|---|
| News records after duplicate removal | 5,780,897 |
| Backdated status removed | 1, dated 1975 |
| User-to-page posts removed | 21,432 |
| Event posts removed | 1 |
| Music posts removed | 2 |
| Posts without discernible type removed | 4,353 |
| Other outlet exclusion | Posts attributed to BuzzFeed rather than BuzzFeed News; count not given |
| Final news total elsewhere in manuscript | 5,728,502 |

Sources: Appendix B.1, [p. 17](../../manuscript/manuscript.pdf#page=17);
Appendix A, [p. 14](../../manuscript/manuscript.pdf#page=14).

User-to-page posts display the individual author's information rather than the
news organization's identity, which motivates their exclusion as noncomparable
to page-authored posts. The manuscript gives the listed exclusions but not a
complete, ordered attrition ledger with disjoint categories and a count for the
BuzzFeed exclusion. Do not derive an undocumented exclusion category by forcing
these counts to match the final sample. Source: Appendix B.1,
[p. 17](../../manuscript/manuscript.pdf#page=17).

## Non-news cleaning

The same appendix reports **464,103 raw non-news posts**, exclusion of
unidentifiable types, user-authored posts and inappropriate dates, **187,283
user-to-page posts**, and **436,420 final posts**. Those counts do not describe
a consistent subtraction from the stated raw total. They are retained here as
reported, with no preferred correction. See the
[non-news attrition note](../reference/reading-notes.md#non-news-attrition).
Source: Appendix B.1, [p. 17](../../manuscript/manuscript.pdf#page=17).

## Views-based imputation

Appendix B.2.1 reports missing reactions in approximately **10% of Content Library
cases**, not 10% of all news posts. It uses the relationship between views and
reactions to predict missing reactions, allowing outlet-specific intercepts and
view slopes and distinguishing video from non-video posts. Source: Appendix
B.2.1, [p. 18](../../manuscript/manuscript.pdf#page=18).

The specified model is Eq. (B.1):

$$
\mathrm{reactions}_i = \beta_0 + \beta_1\mathrm{Views}_i
+ \sum_{j=1}^{J}\beta_{2j}\mathrm{Outlet}_{ij}
+ \sum_{j=1}^{J}\beta_{3j}\mathrm{Views}_i\mathrm{Outlet}_{ij}
+ \beta_4\mathrm{Video}_i + \epsilon_i.
$$

Here outlet indicators encode source identity, the interactions allow different
view–reaction relationships by outlet, and the video indicator is binary. The
model is fitted to nonmissing reaction outcomes. The manuscript reports:

| Fit statistic | Reported value |
|---|---:|
| Multiple R² | 0.6828 |
| Adjusted R² | 0.6827 |
| F statistic | 17,600 |
| F degrees of freedom | 68 and 556,046 |
| Overall p-value | < 2.2e−16 |

Source: Eq. (B.1) and accompanying text,
[p. 18](../../manuscript/manuscript.pdf#page=18).

Detailed coefficients are omitted because the model includes many interactions.
The prose also says imputation was conducted separately within each outlet;
it does not fully explain whether that means applying outlet-specific predictions
from the displayed model or fitting separate models. The authors argue that
outlet and format specificity preserves engagement patterns. That is their
justification for the method; the passage does not document out-of-sample
validation, treatment of negative predictions, rounding, or propagation of
imputation uncertainty. These details remain unspecified here. Source: Appendix
B.2.1, [p. 18](../../manuscript/manuscript.pdf#page=18).

## Separate imputation statement in Appendix E

Appendix E assigns two purposes to the preliminary negative binomial mixed model:
imputing approximately **1.1% of missing reaction counts**, and generating
expectations and coefficients of variation for changepoint detection. That
model uses quality, posting frequency, outlet and daily effects, rather than
the views-based predictors in Eq. (B.1). Source: Appendix E,
[p. 22](../../manuscript/manuscript.pdf#page=22).

The manuscript does not explicitly connect the denominators, affected records or
execution order of these two imputation accounts. Accordingly, the summary
does not turn them into a single established two-stage procedure. The NB2
specification is explained in
[engagement signals](../methods/engagement-signals-and-changepoints.md#preliminary-negative-binomial-model);
the ambiguity is collected in
[reading notes](../reference/reading-notes.md#imputation-accounts).
Sources: Appendix B.2.1, [p. 18](../../manuscript/manuscript.pdf#page=18);
Appendix E, [p. 22](../../manuscript/manuscript.pdf#page=22).
