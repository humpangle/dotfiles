if [[ "$1" =~ ^/ ]]; then
  env_file_abs_path="$1"
else
  env_file_abs_dir="$(
    (cd -- "$(dirname "$1")" || exit) >/dev/null 2>&1
    pwd -P
  )"

  env_file_abs_path="$env_file_abs_dir/$1"
fi

new_asbolute_file_path="$env_file_abs_path.n"
rm -rf "$new_asbolute_file_path"

declare -A env_key_to_value_map

# shellcheck disable=2013
for line in $(grep -v '^#' "$env_file_abs_path" | awk '{print $1}'); do
  key=$(echo "$line" | cut -d '=' -f 1)
  val=$(echo "$line" | cut -d '=' -f 2-)

  for line_with_varirables in $(echo "$val" | grep -Po '\$\{\K.+?(?=\})'); do
    variable_text="\${$line_with_varirables}"
    variable_val="${env_key_to_value_map[$line_with_varirables]}"

    if [[ -z "$variable_val" ]]; then
      variable_val=${!line_with_varirables}
    fi

    val="${val//$variable_text/$variable_val}"
  done

  env_key_to_value_map["$key"]="${val}"
done


for key in "${!env_key_to_value_map[@]}"; do
  echo "$key=${env_key_to_value_map[$key]}" >>"$new_asbolute_file_path"
  echo "$key=${env_key_to_value_map[$key]}"
done
