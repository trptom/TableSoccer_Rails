module MatchesHelper
  def preprocess_attendance(match)
    ret = []
    dates = match.possible_dates.order(:start_time)
    
    for date in dates
      Rails.logger.info "DATE OK : " + date.to_s
      
      last_players = []
      total_duration = (date.end_time - date.start_time)
      
      obj = {
        :date => date,
        :change => [],
        :sequence => []
      }
      
      for selection in date.possible_date_selections
        obj[:change] << {
          :selection => selection,
          :ts => selection.start_time,
          :dir => 1
        }
        
        obj[:change] << {
          :selection => selection,
          :ts => selection.end_time,
          :dir => -1
        }
      end
      
      # sort all changes by their timestamp to allow easilly count sequences
      obj[:change].sort_by{|e| e[:ts]}
      
      # count all sequences (sequence means some part of time with constant attendance)
      for change in obj[:change]
        if (change[:dir] > 0)
          last_players << change[:selection].player
        end
        if (change[:dir] < 0)
          last_players.delete(change[:selection].player)
        end
        
        p = last_players.clone
        
        obj[:sequence] << {
          :offset => (change[:ts] - date.start_time),
          :players => p
        }
      end
      
      # count durations for all sequences
      for a in 1..obj[:sequence].size-1
        obj[:sequence][a-1][:duration] = obj[:sequence][a][:offset] - obj[:sequence][a-1][:offset]
      end
      # last sequence durates until end time
      if obj[:sequence][obj[:sequence].size-1][:offset] < total_duration
        obj[:sequence][obj[:sequence].size-1][:duration] = total_duration - obj[:sequence][obj[:sequence].size-1][:offset]
      else
        obj[:sequence][obj[:sequence].size-1][:duration] = 0
      end
      
      # count percentage, element class and title
      for s in obj[:sequence]
        s[:perc] = s[:duration].to_i / total_duration * 100
        s[:class] = s[:players].size >= 6 ? "p6plus" : "p#{s[:players].size}"
        s[:title] = I18n.l(date.start_time + s[:offset], :format => :short) + " ... " + I18n.l(date.start_time + s[:offset] + s[:duration], :format => :short) + " - "
        if (s[:players].size == 0)
          s[:title] += I18n.t("messages.base.nobody")
        else
          for p in s[:players]
            s[:title] += p.nick_or_name
            if p != s[:players].last
              s[:title] += ", "
            end
          end
        end
      end
      
      if obj[:sequence].size == 0
        obj[:sequence] << {
          :offset => 0,
          :players => [],
          :duration => total_duration
        }
      else
        ofs_0 = obj[:sequence][0][:offset]
        
        if ofs_0 > 0
          obj[:sequence].insert(0, {
            :offset => 0,
            :players => [],
            :duration => ofs_0.to_i
          })
        end
      end
      
      ret << obj
    end
    
    return ret;
  end
  
end
