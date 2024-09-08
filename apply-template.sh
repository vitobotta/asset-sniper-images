#!/usr/bin/env bash
set -Eeuox pipefail

[ -f tools.json ] # run "versions.sh" first

jqt='templates/.jq-template.awk'

if [ "$#" -eq 0 ]; then
	tools="$(jq -r 'keys | map(@sh) | join(" ")' tools.json)"
	eval "set -- $tools"
fi

generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS AUTO-GENERATED VIA "apply-templates.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#

	EOH
}

for tool; do
	export tool

	rm -rf "Docker/$tool/"

    install="$(jq -r '.[env.tool].install | select(.) | map(@sh) | join(" \\ \n\t&& ")' tools.json | tr -d '\047')"

    type="$(jq -r '.[env.tool].type | select(.)' tools.json)"

    echo "processing $tool ..."
    mkdir -p "Docker/$tool"

    case "$type" in
	    bare)
            template='Dockerfile-bare.template'
            ;;
        python)
            template='Dockerfile-python.template'
            ;;

        *)
            template='Dockerfile-go.template'
            ;;
    esac

    export install
    
    {
        generated_warning
        gawk -f "$jqt" "templates/$template"
    } > "Docker/$tool/Dockerfile"

done


function install_tools() {

	eval pip3 install -I -r requirements.txt $DEBUG_STD

	printf "${bblue} Running: Installing Golang tools (${#gotools[@]})${reset}\n\n"
	go env -w GO111MODULE=auto
	go_step=0
	for gotool in "${!gotools[@]}"; do
		go_step=$((go_step + 1))
		if [[ $upgrade_tools == "false" ]]; then
			res=$(command -v "$gotool") && {
				echo -e "[${yellow}SKIPPING${reset}] $gotool already installed in...${blue}${res}${reset}"
				continue
			}
		fi
		eval ${gotools[$gotool]} $DEBUG_STD
		exit_status=$?
		if [[ $exit_status -eq 0 ]]; then
			printf "${yellow} $gotool installed (${go_step}/${#gotools[@]})${reset}\n"
		else
			printf "${red} Unable to install $gotool, try manually (${go_step}/${#gotools[@]})${reset}\n"
			double_check=true
		fi
	done

	printf "${bblue}\n Running: Installing repositories (${#repos[@]})${reset}\n\n"
    
    # Repos with special configs
	eval git clone https://github.com/projectdiscovery/nuclei-templates ${NUCLEI_TEMPLATES_PATH} $DEBUG_STD
	eval git clone https://github.com/geeknik/the-nuclei-templates.git ${NUCLEI_TEMPLATES_PATH}/extra_templates $DEBUG_STD
	eval git clone https://github.com/projectdiscovery/fuzzing-templates ${tools}/fuzzing-templates $DEBUG_STD
	eval nuclei -update-templates update-template-dir ${NUCLEI_TEMPLATES_PATH} $DEBUG_STD
	cd "${dir}" || {
		echo "Failed to cd to $dir in ${FUNCNAME[0]} @ line ${LINENO}"
		exit 1
	}
	eval git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git "${dir}"/sqlmap $DEBUG_STD
	eval git clone --depth 1 https://github.com/drwetter/testssl.sh.git "${dir}"/testssl.sh $DEBUG_STD
	eval $SUDO git clone https://gitlab.com/exploit-database/exploitdb /opt/exploitdb $DEBUG_STD

	# Standard repos installation
	repos_step=0
	for repo in "${!repos[@]}"; do
		repos_step=$((repos_step + 1))
		if [[ $upgrade_tools == "false" ]]; then
			unset is_installed
			unset is_need_dl
			[[ $repo == "Gf-Patterns" ]] && is_need_dl=1
			[[ $repo == "gf" ]] && is_need_dl=1
			res=$(command -v "$repo") && is_installed=1
			[[ -z $is_need_dl ]] && [[ -n $is_installed ]] && {
				# HERE: not installed yet.
				echo -e "[${yellow}SKIPPING${reset}] $repo already installed in...${blue}${res}${reset}"
				continue
			}
		fi
		eval git clone --filter="blob:none" https://github.com/${repos[$repo]} "${dir}"/$repo $DEBUG_STD
        eval cd "${dir}"/$repo $DEBUG_STD
		eval git pull $DEBUG_STD
		exit_status=$?
		if [[ $exit_status -eq 0 ]]; then
			printf "${yellow} $repo installed (${repos_step}/${#repos[@]})${reset}\n"
		else
			printf "${red} Unable to install $repo, try manually (${repos_step}/${#repos[@]})${reset}\n"
			double_check=true
		fi
		if ([[ -z $is_installed ]] && [[ $upgrade_tools == "false" ]]) || [[ $upgrade_tools == "true" ]]; then
            if [[ -s "requirements.txt" ]]; then
                eval $SUDO pip3 install -r requirements.txt $DEBUG_STD
            fi
            if [[ -s "setup.py" ]]; then
                eval $SUDO pip3 install . $DEBUG_STD
            fi
            if [[ "massdns" == "$repo" ]]; then
                eval make $DEBUG_STD && strip -s bin/massdns && eval $SUDO cp bin/massdns /usr/local/bin/ $DEBUG_ERROR
            fi
            if [[ "gitleaks" == "$repo" ]]; then
                eval make build $DEBUG_STD && eval $SUDO cp ./gitleaks /usr/local/bin/ $DEBUG_ERROR
            fi
            if [[ "nomore403" == "$repo" ]]; then
                eval go get $DEBUG_STD && eval go build $DEBUG_STD && eval chmod +x ./nomore403 $DEBUG_STD
            fi
			if [[ "ffufPostprocessing" == "$repo" ]]; then
				eval git reset --hard origin/main $DEBUG_STD
				eval git pull $DEBUG_STD
				eval go build -o ffufPostprocessing main.go $DEBUG_STD && eval chmod +x ./ffufPostprocessing $DEBUG_STD
			fi
			if [[ "misconfig-mapper" == "$repo" ]]; then
				eval git reset --hard origin/main $DEBUG_STD
				eval git pull $DEBUG_STD
				eval go build -o misconfig-mapper $DEBUG_STD && eval chmod +x ./misconfig-mapper $DEBUG_STD
            fi
        fi
		if [[ "gf" == "$repo" ]]; then
            eval cp -r examples ~/.gf $DEBUG_ERROR
        elif [[ "Gf-Patterns" == "$repo" ]]; then
            eval mv ./*.json ~/.gf $DEBUG_ERROR
        fi
        cd "${dir}" || {
			echo "Failed to cd to $dir in ${FUNCNAME[0]} @ line ${LINENO}"
			exit 1
		}
	done

	eval notify $DEBUG_STD
	eval subfinder $DEBUG_STD
	eval subfinder $DEBUG_STD
}