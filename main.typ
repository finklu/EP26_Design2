#import "fhj-iee-template.typ": *
#import "helpers/lib.typ": *

// ==========================================================
// USER CONFIGURATION
// ==========================================================

#show: doc => fhj-iee-template(
  // Metadata
  title: "Evaluation Board with MSP430F5659",
  subtitle: "Electronic Packaging",
  authors: (
    "Lucas Fink",
  ),
  program: PROGRAM_EEM,
  semester: "WS2026",
  language: "en",
  doc-type: "report",
  show-list-of: (),
  bib-file: "/helpers/bib/ECEtempBib.bib",
  bib-style: "ieee",
  report-ai-declaration: [


    #figure(
      table(
        columns: (1fr, auto, 1fr),
        align: (left, left, left),
        stroke: 0.5pt + luma(200),
        fill: (_, row) => if row == 0 { luma(230) } else if calc.odd(row) { luma(250) } else { none },

        table.header[*AI Tool*][*Area of Application*][*Purpose & Scope of Usage*],
        [Google Gemini (Hydrogren, Nov. 2026)], [Chapter 1-4], [Assistance in structuring report chapters, summarizing component selection rationale. Spelling, grammar, and technical phrasing review. ],
     
      ),
      caption: [Used AI tools during report creation],
    ) <tab:ai-declaration>

    All generated content was critically reviewed and finalized by the author.
  ],

  doc,
)

#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zap:0.6.0"

#include "chapters/report.typ"