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
    | . as $g
    | [
        ($g.startTimeUTC
          | fromdateiso8601
          | . - (8*3600)
          | strftime("%I:%M %p")),
        ($g.awayTeam.abbrev + " @ " + $g.homeTeam.abbrev),
        (
          if $g.gameState=="OFF" or $g.gameState=="FINAL" then
            ($g.awayTeam.score|tostring) + " - " + ($g.homeTeam.score|tostring) + " FINAL"
            + (if $g.gameOutcome.otPeriods > 0 or $g.gameOutcome.lastPeriodType=="OT" then " OT" else "" end)
            + (if $g.gameOutcome.lastPeriodType=="SO" then " SO" else "" end)
          elif $g.gameState=="LIVE" or $g.gameState=="CRIT" then
            ($g.awayTeam.score|tostring) + " - " + ($g.homeTeam.score|tostring) + 
            " (" + ($g.periodDescriptor.number | tostring) + 
            (if $g.periodDescriptor.periodType=="REG" then 
              "nd" 
            elif $g.periodDescriptor.periodType=="OT" then 
              "OT" 
            elif $g.periodDescriptor.periodType=="SO" then 
              "SO" 
            else 
              $g.periodDescriptor.periodType
            end) + 
            (if $g.clock.inIntermission then 
              " - INT"
            else 
              " - " + $g.clock.timeRemaining
            end) + ")"
          else
            "SCHEDULED"
          end
        )
      ]
    | @tsv
  ' |
  awk -F'\t' '
    BEGIN{
      print "┌─────────────┬─────────────────┬─────────────────────┐"
      print "│    Time     │     Matchup     │    Score/Status     │"
      print "├─────────────┼─────────────────┼─────────────────────┤"
    }
    {
      time = sprintf("%-11s", $1)
      matchup = sprintf("%-15s", $2)
      score = sprintf("%-19s", $3)
      print "│ " time " │ " matchup " │ " score " │"
    }
    END{
      if (NR > 0) {
        print "└─────────────┴─────────────────┴─────────────────────┘"
      } else {
        print "│ No games scheduled for today │"
        print "└─────────────────────────────────┘"
      }
    }
  '

echo ""
echo "📊 Game Status Legend:"
echo "  • FINAL - Game completed"
echo "  • (1st - 15:00) - Live game: 1st period with 15:00 remaining"
echo "  • (2nd - INT) - Live game: 2nd period intermission"
echo "  • (3rd - 5:30) - Live game: 3rd period with 5:30 remaining"
echo "  • (OT - 2:15) - Overtime period with 2:15 remaining"
echo "  • SCHEDULED - Game upcoming"
echo "  • OT - Game ended in overtime"
echo "  • SO - Game ended in shootout"
echo ""
