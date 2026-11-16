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

  doc,
)

#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zap:0.6.0"

#include "chapters/report.typ"
