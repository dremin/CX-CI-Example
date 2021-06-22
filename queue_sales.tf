resource "genesyscloud_routing_queue" "Sales" {
  acw_timeout_ms = 60000
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  division_id = data.genesyscloud_auth_division.Home.id
  enable_manual_assignment = true
  enable_transcription = true
  media_settings_call {
    alerting_timeout_sec = 20
    service_level_duration_ms = 20000
    service_level_percentage = 0.8
  }
  name = "Johnson Widgets Sales"
  skill_evaluation_method = "ALL"
  wrapup_codes = [
    genesyscloud_routing_wrapupcode.Transferred.id
  ]
}