# Sampling and collection

[Manuscript guide](../README.md) · [Measurement](measurement-and-quality.md) · [Cleaning](cleaning-and-imputation.md)

## Population and scope

The article studies public Facebook posts by a selected set of major U.S. news
organizations from January 1, 2016 through December 16, 2025: 3,636 days. The
reported final news sample contains **5,728,502 posts from 40 outlets**, attracting
**9,123,838,908 reactions**. The comparison sample contains **436,420 posts from
21 non-news pages**, with **2,270,806,517 reactions**. These are manuscript-reported
sample totals, not independently checked data counts. Sources: §1,
[pp. 1–2](../../manuscript/manuscript.pdf#page=1); §4.1,
[p. 8](../../manuscript/manuscript.pdf#page=8); Appendix A,
[p. 14](../../manuscript/manuscript.pdf#page=14).

Outlets were chosen to span size, political leaning, and trustworthiness or overall
quality. The authors sought all obtainable posts from these outlets, rather than
a probability sample of all U.S. news posts. Section 4.3 explains that a complete,
stable sampling frame is unavailable, the boundary of a news outlet is unclear,
and plausible weighting schemes—outlets, posting volume, views or engagement—
define different target populations. These considerations motivate their mixed
models and equal weighting across quality tiers, but do not make the selected
outlets a representative probability sample. Sources: Appendix A,
[p. 14](../../manuscript/manuscript.pdf#page=14); §4.3,
[pp. 9–10](../../manuscript/manuscript.pdf#page=9).

## Collection sequence and engagement windows

Sotrender supplied the initial news data through access to the Facebook Graph
API. Appendix A describes two collection modes:

1. **Ongoing collection:** posts and interaction metrics retrieved hourly, with
   engagement refreshed over two weeks after publication. The authors describe
   this as the typical peak interaction window.
2. **Historical retrieval:** engagement obtained for older posts that had not been
   captured through ongoing collection, including posts beyond the two-week
   tracking window.

These are two reported collection modes; the manuscript does not establish a
single identical measurement age for every reaction count. Source: Appendix A,
[p. 14](../../manuscript/manuscript.pdf#page=14).

The investigators found outlet-days for which no posts could be obtained. They
randomly sampled 50 day/outlet pairs and compared Sotrender counts with posts
visible on Facebook. They report close agreement except when Sotrender had
captured no posts at all. They note that deletions and retroactively dated posts
can prevent exact agreement. Following this check, they supplemented affected
periods through Facebook's Content Library. This is the authors' reported check
of collection completeness, rather than a documented census of every outlet-day.
Source: Appendix A, [p. 14](../../manuscript/manuscript.pdf#page=14).

Non-news data came entirely from Sotrender and were not supplemented with Content
Library records. Collection-source overlaps and exclusions are described in
[cleaning and imputation](cleaning-and-imputation.md). Source: Appendix B.1,
[p. 17](../../manuscript/manuscript.pdf#page=17).

## News outlet inventory

The following reproduces the outlet identities, tier assignments and primary
medium labels in Table A.1. “Print,” “Broadcast” and “Purely Online” are the
manuscript's categories; they should not be reclassified from contemporary
knowledge. Quality is assigned to the outlet, not individually to its posts.
Source: Appendix A.1, Table A.1,
[p. 15](../../manuscript/manuscript.pdf#page=15).

| Tier | Outlet | Primary medium |
|---|---|---|
| Low | The Blaze | Purely Online |
| Low | Breitbart | Purely Online |
| Low | The Daily Caller | Purely Online |
| Low | Daily Kos | Purely Online |
| Low | The Epoch Times | Print |
| Low | Fox News | Broadcast |
| Low | HuffPost | Purely Online |
| Low | Jacobin Magazine | Print |
| Low | The New Republic | Print |
| Low | Newsmax | Broadcast |
| Low | OANN | Broadcast |
| Low | Quillette | Purely Online |
| Low | Truthout | Purely Online |
| Medium | ABC News | Broadcast |
| Medium | BuzzFeed News | Purely Online |
| Medium | CNN | Broadcast |
| Medium | Democracy Now! | Broadcast |
| Medium | Mother Jones | Print |
| Medium | MSNBC | Broadcast |
| Medium | The New Yorker | Print |
| Medium | Truthdig | Purely Online |
| Medium | The Wall Street Journal | Print |
| Medium | The Week | Print |
| Medium | The Young Turks | Purely Online |
| Medium | Vox | Purely Online |
| Medium | Yahoo News | Purely Online |
| High | AP | Print |
| High | Business Insider | Purely Online |
| High | CNBC | Broadcast |
| High | The Economist | Print |
| High | The Financial Times | Print |
| High | Forbes | Print |
| High | The Hill | Print |
| High | Newsweek | Print |
| High | The New York Times | Print |
| High | NPR | Broadcast |
| High | PBS | Broadcast |
| High | Reuters | Print |
| High | USA Today | Print |
| High | The Washington Post | Print |

The inventory comprises 13 low-, 13 medium-, and 14 high-quality outlets, counted
from Table A.1. Its footnote notes that BuzzFeed News ceased publishing in April
2023, so its March 2025 website traffic understates its earlier scale. The table
does not imply that every outlet contributed posts throughout every epoch.
Source: Table A.1 and its footnotes,
[p. 15](../../manuscript/manuscript.pdf#page=15).

## Non-news comparison pages

Table B.2 lists the following 21 pages. Section 4.1.1 characterizes them as large
shopping/restaurant chains, sports organizations and entertainment brands. Their
scientific role is to supply a comparison trajectory for content expected not
to be directly targeted by news/civic-content suppression. Source: §4.1.1,
[p. 8](../../manuscript/manuscript.pdf#page=8); Table B.2,
[p. 16](../../manuscript/manuscript.pdf#page=16).

| Page | Page | Page |
|---|---|---|
| The Cheesecake Factory | Chipotle Mexican Grill | Cracker Barrel Old Country Store |
| CVS Pharmacy | Disney | Major League Soccer (MLS) |
| MLB | NBA | Netflix |
| NFL | NHL | Paramount+ |
| Peacock TV | PGA Tour | Prime Video |
| Target | Walgreens | Walmart |
| Wendy's | White Castle | WNBA |

Section 2.1 describes these pages as active across the studied period. That
statement supplies the intended comparison frame; it does not supply a
page-by-page completeness table or establish the counterfactual assumption by
itself. See [causal comparisons](../methods/causal-comparisons.md). Source: §2.1,
[p. 5](../../manuscript/manuscript.pdf#page=5).

## Access, ethics and reproducibility statements

Appendix A states that collection used publicly accessible pages, excluded private
user content, respected Graph API authentication and rate limits, and complied
with Meta's terms. It describes Sotrender as an EU company subject to GDPR and
regular Meta audits. These are statements made by the manuscript, not independent
legal or compliance findings of this reference set. Source: Appendix A,
[p. 14](../../manuscript/manuscript.pdf#page=14).

The data-and-materials statement reports an OSF deposit, DOI
`10.17605/OSF.IO/MEHXS`, and a GitHub code repository. Their availability and
contents have not been checked for these summaries. The manuscript also records
funding, author contributions, acknowledgments, and M.W.'s prior Facebook grants
and participation in the 2020 Facebook and Instagram Election Study. Source:
back matter, [p. 13](../../manuscript/manuscript.pdf#page=13).
