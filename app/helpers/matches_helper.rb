module MatchesHelper
  def preprocess_attendance(match)
    ret = []
    dates = match.possible_dates.order(:start_time)
    
    for date in dates
      Rails.logger.info "DATE OK : " + date.to_s
      
      p_sum = 0
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
          :dir => selection.priority
        }
        
        obj[:change] << {
          :selection => selection,
          :ts => selection.end_time,
          :dir => -selection.priority
        }
      end
      
      # sort all changes by their timestamp to allow easilly count sequences
      #obj[:change].sort_by{|e| e[:ts]}
      
      obj[:change].sort! { |a,b| a[:ts].to_i <=> b[:ts].to_i }
      
      # count all sequences (sequence means some part of time with constant attendance)
      for change in obj[:change]
        if (change[:dir] > 0)
          last_players << change[:selection]
        end
        if (change[:dir] < 0)
          id = last_players.find_index(change[:selection])
          if (id != nil) # prevent errors
            last_players.slice!(id)
          end
        end
        
        p_sum += change[:dir]
        p = last_players.clone
        
        obj[:sequence] << {
          :offset => (change[:ts] - date.start_time),
          :sum => p_sum,
          :players => p,
          :total_players => (p_sum.to_f / ATTENDANCE_PRIORITY_MAX.to_f).ceil
        }
      end
      
      # count durations for all sequences
      for a in 1..obj[:sequence].size-1
        obj[:sequence][a-1][:duration] = obj[:sequence][a][:offset] - obj[:sequence][a-1][:offset]
      end
      # last sequence (if has at least 1 sequence) durates until end time
      if obj[:sequence].size > 0
        if obj[:sequence][obj[:sequence].size-1][:offset] < total_duration
          obj[:sequence][obj[:sequence].size-1][:duration] = total_duration - obj[:sequence][obj[:sequence].size-1][:offset]
        else
          obj[:sequence][obj[:sequence].size-1][:duration] = 0
        end
      end
      
      if obj[:sequence].size == 0
        obj[:sequence] << {
          :offset => 0,
          :players => [],
          :duration => total_duration,
          :total_players => 0
        }
      else
        ofs_0 = obj[:sequence][0][:offset]
        
        if ofs_0 > 0
          obj[:sequence].insert(0, {
            :offset => 0,
            :players => [],
            :duration => ofs_0.to_i,
            :total_players => 0
          })
        end
      end
      
      # count percentage, element class and title
      for s in obj[:sequence]
        s[:perc] = s[:duration].to_i / total_duration * 100
        s[:class] = s[:total_players] >= 6 ? "p6plus" : "p#{s[:total_players]}"
        s[:popover_title] = I18n.l(date.start_time + s[:offset], :format => :short) + " ... " + I18n.l(date.start_time + s[:offset] + s[:duration], :format => :short)
        s[:popover_content] = ""
        if (s[:players].size == 0)
          s[:popover_content] += I18n.t("messages.base.nobody")
        else
          for p in s[:players]
            s[:popover_content] += "#{p.player.nick_or_name} (#{p.priority * 100 / ATTENDANCE_PRIORITY_MAX}%)"
            if p != s[:players].last
              s[:popover_content] += ", "
            end
          end
        end
      end
      
      ret << obj
    end
    
    return ret;
  end
  
end
