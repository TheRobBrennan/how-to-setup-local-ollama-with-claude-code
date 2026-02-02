#!/usr/bin/env bash
# NHL games script - Professional client-ready output
# Usage: ./nhl_games.sh [YYYY-MM-DD]
# Defaults to today.

DATE=${1:-$(date +%F)}

# Format date for display
DISPLAY_DATE=$(date -j -f "%Y-%m-%d" "$DATE" "+%A, %B %d, %Y" 2>/dev/null || date -d "$DATE" "+%A, %B %d, %Y" 2>/dev/null || echo "$DATE")

echo ""
echo "🏒 NHL Hockey Games"
echo "📅 $DISPLAY_DATE"
echo ""

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
        ($g.awayTeam.abbrev + " @ " + $g.homeTeam.abbrev),
        (
          if $g.gameState=="OFF" or $g.gameState=="FINAL" then
            ($g.awayTeam.score|tostring) + " - " + ($g.homeTeam.score|tostring)
          else
            ($g.awayTeam.score|tostring) + " - " + ($g.homeTeam.score|tostring) + " (LIVE)"
          end
        )
        + (if $g.gameOutcome.otPeriods > 0 or $g.gameOutcome.lastPeriodType=="OT" then " OT" else "" end)
        + (if $g.gameOutcome.lastPeriodType=="SO" then " SO" else "" end)
      ]
    | @tsv
  ' |
  awk -F'\t' '
    BEGIN{
      print "┌─────────────┬─────────────────┬─────────────────┐"
      print "│    Time     │     Matchup     │   Score/Status  │"
      print "├─────────────┼─────────────────┼─────────────────┤"
    }
    {
      time = sprintf("%-11s", $1)
      matchup = sprintf("%-15s", $2)
      score = sprintf("%-15s", $3)
      print "│ " time " │ " matchup " │ " score " │"
    }
    END{
      if (NR > 0) {
        print "└─────────────┴─────────────────┴─────────────────┘"
      } else {
        print "│ No games scheduled for today │"
        print "└─────────────────────────────────┘"
      }
    }
  '

echo ""
echo "📊 Game Status Legend:"
echo "  • Regular time (e.g., 3 - 2)"
echo "  • Overtime (OT)"
echo "  • Shootout (SO)"
echo "  • Live games marked as (LIVE)"
echo ""
