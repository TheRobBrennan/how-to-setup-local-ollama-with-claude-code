#!/usr/bin/env bash
# NHL games script
# Usage: ./nhl_games.sh [YYYY-MM-DD]
# Defaults to today.

DATE=${1:-$(date +%F)}

curl -s "https://sploosh-ai-hockey-analytics.vercel.app/api/nhl/scores?date=$DATE" |
  jq -r '
    .games[]
    | select(.awayTeam.score != null and .homeTeam.score != null)
    | . as $g
    | [
        ($g.startTimeUTC
          | fromdateiso8601
          | . - (8*3600)
          | strftime("%I:%M %p")),
        ($g.awayTeam.abbrev + " vs " + $g.homeTeam.abbrev),
        (
          if $g.gameState=="OFF" or $g.gameState=="FINAL" then
            ($g.awayTeam.score|tostring) + " - " + ($g.homeTeam.score|tostring)
          else
            ($g.awayTeam.score|tostring) + " - " + ($g.homeTeam.score|tostring) + " (live)"
          end
        )
        + (if $g.gameOutcome.otPeriods > 0 or $g.gameOutcome.lastPeriodType=="OT" then " (OT)" else "" end)
        + (if $g.gameOutcome.lastPeriodType=="SO" then " (SO)" else "" end)
      ]
    | @tsv
  ' |
  awk -F'\t' '
    BEGIN{
      print "| Time (PST) | Match‑up | Score / Status |";
      print "|------------|----------|----------------|";
    }
    { print "| " $1 " | " $2 " | " $3 " |" }
  '
