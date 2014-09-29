# coding:utf-8

module ApplicationHelper
  def get_team_options
    tmp = Team.all
    ret = Array.new
    for team in tmp
      ret << [team.name, team.id]
    end
    if ret.length == 0
      ret << [ I18n.t("messages.base.no_team"), nil]
    end
    return ret
  end

  def get_league_options
    tmp = League.all
    ret = Array.new
    for league in tmp
      ret << [league.name, league.id]
    end
    if ret.length == 0
      ret << [ I18n.t("messages.base.no_league"), nil ]
    end
    return ret
  end

  def get_match_options
    tmp = Match.order(:start_date).all
    ret = Array.new
    for match in tmp
      ret << [match.start_date + ", " + match.team_home.name + " vs. " + match.team_away.name, match.id]
    end
    if ret.length == 0
      ret << [ I18n.t("messages.base.no_match"), nil ]
    end
    return ret
  end

  def get_player_options(atts)
    tmp = atts && atts[:team_id] ? Player.where(:team_id => atts[:team_id]).order(:nick).all : Player.order(:nick).all
    ret = Array.new

    if (atts && atts[:before])
      for item in atts[:before]
        ret << item
      end
    end

    if (atts && atts[:empty_allowed])
      ret << [I18n.t("messages.base.no_player"), nil]
    end

    for player in tmp
      ret << [get_player_name(player), player.id]
    end
    if ret.length == 0 && (atts && atts[:add_item_when_empty] && !atts[:empty_allowed])
      ret << [ atts[:add_item_when_empty].kind_of?(String) ? atts[:add_item_when_empty] : I18n.t("messages.base.no_player"), nil ]
    end

    if (atts && atts[:after])
      for item in atts[:after]
        ret << item
      end
    end

    return ret
  end

  def get_game_type_options
    ret = Array.new
    ret << [ I18n.t(GAME_TYPE_STR[GAME_TYPE_SINGLE]), GAME_TYPE_SINGLE.to_s ]
    ret << [ I18n.t(GAME_TYPE_STR[GAME_TYPE_DOUBLE]), GAME_TYPE_DOUBLE.to_s ]
    ret << [ I18n.t(GAME_TYPE_STR[GAME_TYPE_TWO_BALL]), GAME_TYPE_TWO_BALL.to_s ]
    ret << [ I18n.t(GAME_TYPE_STR[GAME_TYPE_FOURS]), GAME_TYPE_FOURS.to_s ]
    return ret
  end

  def get_current_user_player
    return current_user ? current_user.player : nil
  end

  def get_current_user_team
    player = get_current_user_player
    return player ? player.team : nil
  end

  def get_player_name(player)
    if player.nick
      return player.nick
    else
      if player.first_name && player.second_name
        return player.first_name + " " + player.second_name
      else
        if (player.second_name)
          return player.second_name
        end
        if (player.first_name)
          return player.first_name
        end
      end
    end
  end

  def link_to_new(title, link)
    title = title ? title : I18n.t('messages.'+params[:controller]+'.'+params[:action]+'.new')
    return link_to title, link, :class => "btn"
  end

  def link_to_show(title, link)
    title = title ? title : I18n.t('messages.base.show')
    return link_to title, link, :class => "btn"
  end

  def link_to_edit(title, link)
    title = title ? title : I18n.t('messages.base.edit')
    return link_to title, link, :class => "btn"
  end

  def link_to_delete(title, link)
    title = title ? title : I18n.t('messages.base.delete')
    return link_to title, link, :class => "btn", method: :delete, data: { confirm: I18n.t('messages.base.are_you_sure') }
  end
  
  # Function which determines asset existency. When Asset does not exist,
  # it returns false (not error).
  def check_asset_existency(asset)
    logger.info "searching asset: " + asset
    return Rails.application.assets.find_asset asset
  rescue
    logger.info "asset error: " + asset
    return false;
  end

  def get_additional_styles
    ctrl_style_url = "skins/modern/pages/" + params[:controller] + "/overall.css"
    page_style_url = "skins/modern/pages/" + params[:controller] + "/" + params[:action] + ".css"

    res = Array.new

    if check_asset_existency ctrl_style_url
      res << "/assets/#{ctrl_style_url}"
    end

    if check_asset_existency page_style_url
      res << "/assets/#{page_style_url}"
    end
	
    logger.info "styles res: " + res.to_s
    return res
  end

  def get_additional_scripts
    ctrl_script_url = "pages/" + params[:controller] + "/overall.js"
    page_script_url = "pages/" + params[:controller] + "/" + params[:action] + ".js"

    res = Array.new

    if check_asset_existency ctrl_script_url
      res << "/assets/#{ctrl_script_url}"
    end

    if check_asset_existency page_script_url
      res << "/assets/#{page_script_url}"
    end

    logger.info "scripts res: " + res.to_s
    return res
  end
end
