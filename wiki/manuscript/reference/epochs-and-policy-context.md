# Epochs and policy context

[Manuscript guide](../README.md) · [Changepoint method](../methods/engagement-signals-and-changepoints.md) · [Results](../results/suppression-and-recovery.md)

## Epoch calendar

The manuscript reports 11 detected changepoints and 12 epochs. Epoch 0 precedes
the first boundary; later epoch numbers correspond to the boundary from which
they start. The calendar below transcribes Table G.9, also used by Tables H.11
and H.12. Dates are shown as calendar dates; the PDF tables do not specify
sub-day assignment rules. Sources: §2,
[p. 3](../../manuscript/manuscript.pdf#page=3); Tables G.9/H.11/H.12,
[p. 29](../../manuscript/manuscript.pdf#page=29),
[pp. 31–32](../../manuscript/manuscript.pdf#page=31).

| Epoch | Start | End boundary or observation endpoint | Role in the manuscript's comparisons |
|---|---|---|---|
| 0 | 2016-01-01 | 2016-06-20 | Part of the five-epoch baseline. |
| 1 | 2016-06-20 | 2017-03-06 | Election/inauguration-associated high engagement. |
| 2 | 2017-03-06 | 2018-03-19 | Part of the baseline. |
| 3 | 2018-03-19 | 2020-04-06 | Long pre-policy interval. |
| 4 | 2020-04-06 | 2021-03-01 | Focal pre-suppression reference; last baseline epoch. |
| 5 | 2021-03-01 | 2021-08-02 | First epoch after the February 2021 announcement. |
| 6 | 2021-08-02 | 2022-10-10 | First significant cumulative news/non-news shortfall in H.12. |
| 7 | 2022-10-10 | 2023-06-26 | Further engagement decline. |
| 8 | 2023-06-26 | 2024-09-02 | Suppression trough; focal comparison with 4 and 11. |
| 9 | 2024-09-02 | 2025-03-10 | Election-period recovery; spans the January 2025 announcement. |
| 10 | 2025-03-10 | 2025-09-22 | Continued recovery following the reversal. |
| 11 | 2025-09-22 | 2025-12-16 | Final observed interval; focal recovery endpoint. |

Sources for the interpretive roles: §2,
[pp. 3–5](../../manuscript/manuscript.pdf#page=3); Table H.12,
[p. 32](../../manuscript/manuscript.pdf#page=32); Appendix I,
[p. 33](../../manuscript/manuscript.pdf#page=33).

The **0–4 geometric baseline** and **epoch 4 alone** are distinct references.
Likewise, the rebound begins in epoch 9, before the first detected boundary
following the reversal announcement. Calendar intervals and policy periods
therefore overlap without being identical. Sources: §4.4,
[pp. 10–11](../../manuscript/manuscript.pdf#page=10); Table F.7,
[p. 25](../../manuscript/manuscript.pdf#page=25).

## Proximal events in Table F.7

The table below summarizes every event group in Table F.7. Event dates and
descriptions are **as reported by the manuscript**, not independently verified
historical claims. Parenthetical numbers identify the manuscript's bibliography;
labels such as 5b identify annotations in its figures. All rows source to
Table F.7, [p. 25](../../manuscript/manuscript.pdf#page=25).

| Changepoint and detected date | Social/political events | Algorithmic events listed nearby |
|---|---|---|
| 1 · 2016-06-20 | U.S. presidential campaigning, undated (1a). | June 29: prioritize friends over pages (53); August 4: reduce common clickbait headlines (54). |
| 2 · 2017-03-06 | January 20: Trump inauguration (2a). | January 31: spam and real-time network signals (55); April 25: algorithmically selected related articles (56). |
| 3 · 2018-03-19 | February 14: Parkland shooting (58). | January 11: people over pages and engagement over passive viewing (3a; 7); January 19: trustworthiness-rating trials (57). |
| 4 · 2020-04-06 | Presidential campaigning, undated (4a); January–March COVID spread; May 25: George Floyd's murder (59). | January 30: COVID misinformation measures (23); June 30: original reporting and transparent authorship (60); July 2: user surveys for unwanted-content reduction (61). |
| 5 · 2021-03-01 | January 20: Biden inauguration (5a). | February 10: “War on News” announcement, with U.S. tests live by February 17 (5b; 8); February 16: demote low-quality and boost high-quality news (8). |
| 6 · 2021-08-02 | July 2: U.S. withdrawal from Afghanistan (6a; 62). | August 31: prioritize feedback over engagement in news-reduction tests (8). |
| 7 · 2022-10-10 | October 27: Twitter takeover (63); November 7: U.S. midterms, using the date printed in F.7. | May 24: expand tests reducing content/share weights (7a; 8); July 19: confirmation of deployment (8). |
| 8 · 2023-06-26 | None listed in this event group. | April 20: identify political posts through comments and limit successive political posts (8a; 8); August 1: Canada news ban (8b; 28). |
| 9 · 2024-09-02 | U.S. presidential campaigning, undated (9a). | September 4: rollout of user controls for political content (8). |
| 10 · 2025-03-10 | January 20: second Trump inauguration (10b). | January 7: end political-content deprioritization, with opt-out controls (10a; 9); March 27: dedicated friends tab (64). |
| 11 · 2025-09-22 | September 10: Charlie Kirk assassination (11a; 65). | December 5: real-time news and partnered organizations in Meta AI (11b; 66). |

Do not interpret every listed event as a direct treatment of U.S. news pages.
For example, the Canada news ban appears as a contextual candidate in F.7,
while Appendix L classifies that event as leaving U.S. users unaffected. Source:
Table F.7, [p. 25](../../manuscript/manuscript.pdf#page=25); Appendix L table,
[p. 40](../../manuscript/manuscript.pdf#page=40).

## How events were associated with boundaries

Appendix F.1 says the authors reviewed announcements within one or two months
of detected changes and qualitatively considered the direction and magnitude
of engagement changes alongside social events. They allow announcements to
precede or follow effective deployment. They argue that pre-2021 changes often
align with social events, whereas later changes more clearly align with news
policy. Source: Appendix F.1,
[p. 24](../../manuscript/manuscript.pdf#page=24).

Some examples and dates in F.1 are not consistent with F.7, including the
ordering of the first changepoint and the June 2016 announcement and the number
assigned to the October 2022 boundary. Some event distances also exceed the
stated one-to-two-month window. These remain
[reading notes](reading-notes.md#changepoint-event-matching), not corrected
annotations. Sources: Appendix F.1 and Table F.7,
[pp. 24–25](../../manuscript/manuscript.pdf#page=24).

## The broad policy timeline

Appendix L describes **413 publicly announced changes**, covering January 1,
2016 through January 16, 2026, extending beyond the post-data endpoint. The
sources include Meta Newsroom, the former Meta Journalism Project timeline,
community-standards and content-distribution changes, the 2016–2021 Integrity
Timeline, Oversight Board decisions, threat-disruption reports, crisis-specific
reports, and an external 2020-election intervention timeline. These are the
sources cited in the PDF, not an additional source search for this guide.
Source: Appendix L, [p. 39](../../manuscript/manuscript.pdf#page=39).

The article deliberately uses “algorithmic change” broadly: ranking changes,
removal rules, feature additions/removals, fact-checking displays, news-feed
organization and coordinated-account bans can all influence visibility or
engagement. A single announcement can yield several rows for distinct efforts;
one row is therefore not guaranteed to correspond to one technical algorithm
deployment. Source: Appendix L,
[p. 39](../../manuscript/manuscript.pdf#page=39).

| Timeline field | Meaning in the appendix |
|---|---|
| Date | Change date or announcement date when implementation timing is undisclosed. |
| Product affected | Accounts, feed, search, governance or bans, with occasional unresolved entries. |
| Change category | Algorithm, feature, policy or transparency; the printed table also includes testing. |
| U.S. relevance | Global, U.S.-only, U.S.-unaffected, and some unclear entries. The prose says undisclosed scope was assumed global. |
| Source title and link | Announcement or other cited source supporting the entry. |

Sources: Appendix L introduction and table,
[pp. 39–46](../../manuscript/manuscript.pdf#page=39).

The table runs broadly backward from recent to older changes across pages 40–46.
It is a policy-context resource and the source pool for qualitative event
matching, rather than a set of 413 separately estimated intervention effects.
These summaries preserve its stated scope and indexing role without reproducing
all rows or verifying its external links. Sources: §4.2,
[p. 8](../../manuscript/manuscript.pdf#page=8); Appendix L,
[pp. 39–46](../../manuscript/manuscript.pdf#page=39).
