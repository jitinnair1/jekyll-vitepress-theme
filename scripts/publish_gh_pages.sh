#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"

if [[ -z "${MODE}" ]]; then
  echo "Usage: publish_gh_pages.sh <single|next|release>"
  exit 1
fi

if [[ "${MODE}" != "single" && "${MODE}" != "next" && "${MODE}" != "release" ]]; then
  echo "Invalid mode '${MODE}'. Use 'single', 'next', or 'release'."
  exit 1
fi

WORKTREE_DIR="${WORKTREE_DIR:-$(mktemp -d)}"
VERSIONS_FILE="${VERSIONS_FILE:-_data/versions.yml}"
SITE_ROOT_DIR="${SITE_ROOT_DIR:-_site}"
SITE_NEXT_DIR="${SITE_NEXT_DIR:-_site_next}"
SITE_LATEST_DIR="${SITE_LATEST_DIR:-_site_latest}"
SITE_RELEASE_DIR="${SITE_RELEASE_DIR:-_site_release}"
RELEASE_VERSION="${RELEASE_VERSION:-}"
DOCS_BASE_PATH="${DOCS_BASE_PATH:-}"
LEGACY_VERSION_REDIRECTS="${LEGACY_VERSION_REDIRECTS:-0.9.0}"
COMMIT_MESSAGE="${COMMIT_MESSAGE:-docs: publish ${MODE}}"

normalize_base_path() {
  local raw="${1:-}"
  local trimmed="${raw//[[:space:]]/}"
  if [[ -z "${trimmed}" || "${trimmed}" == "/" ]]; then
    echo ""
    return
  fi
  if [[ "${trimmed}" != /* ]]; then
    trimmed="/${trimmed}"
  fi
  echo "${trimmed%/}"
}

write_redirect_file() {
  local output_path="${1}"
  local target_path="${2}"
  cat > "${output_path}" <<HTML
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="refresh" content="0; url=${target_path}">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Redirecting…</title>
    <script>window.location.replace("${target_path}");</script>
  </head>
  <body>
    <p>Redirecting to <a href="${target_path}">${target_path}</a>…</p>
  </body>
</html>
HTML
}

cleanup() {
  set +e
  git -C "${GITHUB_WORKSPACE:-.}" worktree remove --force "${WORKTREE_DIR}" >/dev/null 2>&1 || true
  rm -rf "${WORKTREE_DIR}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

if git ls-remote --exit-code --heads origin gh-pages >/dev/null 2>&1; then
  git fetch --no-tags origin gh-pages
  git worktree add --detach "${WORKTREE_DIR}" origin/gh-pages
  git -C "${WORKTREE_DIR}" checkout -B gh-pages
else
  git worktree add --detach "${WORKTREE_DIR}"
  git -C "${WORKTREE_DIR}" checkout --orphan gh-pages
  # Keep the worktree metadata and remove all checked out files.
  find "${WORKTREE_DIR}" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
fi

mkdir -p "${WORKTREE_DIR}"

EXISTING_CNAME=""
if [[ -f "${WORKTREE_DIR}/CNAME" ]]; then
  EXISTING_CNAME="$(cat "${WORKTREE_DIR}/CNAME")"
fi

BASE_PATH="$(normalize_base_path "${DOCS_BASE_PATH}")"
ROOT_TARGET="${BASE_PATH}/"
if [[ -z "${BASE_PATH}" ]]; then
  ROOT_TARGET="/"
fi

if [[ "${MODE}" == "single" ]]; then
  if [[ ! -d "${SITE_ROOT_DIR}" ]]; then
    echo "Missing ${SITE_ROOT_DIR}"
    exit 1
  fi

  rsync -a --delete "${SITE_ROOT_DIR}/" "${WORKTREE_DIR}/"

  if [[ -n "${EXISTING_CNAME}" && ! -f "${WORKTREE_DIR}/CNAME" ]]; then
    printf '%s\n' "${EXISTING_CNAME}" > "${WORKTREE_DIR}/CNAME"
  fi

  mkdir -p "${WORKTREE_DIR}/latest"
  write_redirect_file "${WORKTREE_DIR}/latest/index.html" "${ROOT_TARGET}"

  IFS=', ' read -r -a LEGACY_VERSIONS <<< "${LEGACY_VERSION_REDIRECTS}"
  for legacy_version in "${LEGACY_VERSIONS[@]}"; do
    if [[ -z "${legacy_version}" ]]; then
      continue
    fi
    mkdir -p "${WORKTREE_DIR}/v/${legacy_version}"
    write_redirect_file "${WORKTREE_DIR}/v/${legacy_version}/index.html" "${ROOT_TARGET}"
  done
fi

if [[ "${MODE}" == "next" ]]; then
  if [[ ! -d "${SITE_NEXT_DIR}" ]]; then
    echo "Missing ${SITE_NEXT_DIR}"
    exit 1
  fi
  mkdir -p "${WORKTREE_DIR}/next"
  rsync -a --delete "${SITE_NEXT_DIR}/" "${WORKTREE_DIR}/next/"
fi

if [[ "${MODE}" == "release" ]]; then
  if [[ -z "${RELEASE_VERSION}" ]]; then
    echo "RELEASE_VERSION is required for release mode"
    exit 1
  fi
  if [[ ! -d "${SITE_RELEASE_DIR}" ]]; then
    echo "Missing ${SITE_RELEASE_DIR}"
    exit 1
  fi
  if [[ ! -d "${SITE_LATEST_DIR}" ]]; then
    echo "Missing ${SITE_LATEST_DIR}"
    exit 1
  fi

  mkdir -p "${WORKTREE_DIR}/v/${RELEASE_VERSION}" "${WORKTREE_DIR}/latest"
  rsync -a --delete "${SITE_RELEASE_DIR}/" "${WORKTREE_DIR}/v/${RELEASE_VERSION}/"
  rsync -a --delete "${SITE_LATEST_DIR}/" "${WORKTREE_DIR}/latest/"
fi

if [[ "${MODE}" != "single" ]]; then
  if [[ ! -f "${VERSIONS_FILE}" ]]; then
    echo "Missing ${VERSIONS_FILE}"
    exit 1
  fi
  cp "${VERSIONS_FILE}" "${WORKTREE_DIR}/versions.yml"

  TARGET_DIR="next"
  if [[ -f "${WORKTREE_DIR}/latest/index.html" ]]; then
    TARGET_DIR="latest"
  fi

  REDIRECT_TEMPLATE="scripts/templates/gh_pages_redirect.html"
  if [[ ! -f "${REDIRECT_TEMPLATE}" ]]; then
    echo "Missing ${REDIRECT_TEMPLATE}"
    exit 1
  fi
  sed "s|__TARGET_DIR__|${TARGET_DIR}|g" "${REDIRECT_TEMPLATE}" > "${WORKTREE_DIR}/index.html"
fi

touch "${WORKTREE_DIR}/.nojekyll"

git -C "${WORKTREE_DIR}" add -A
if git -C "${WORKTREE_DIR}" diff --cached --quiet; then
  echo "No gh-pages changes to publish."
  exit 0
fi

git -C "${WORKTREE_DIR}" config user.name "${GIT_AUTHOR_NAME:-github-actions[bot]}"
git -C "${WORKTREE_DIR}" config user.email "${GIT_AUTHOR_EMAIL:-41898282+github-actions[bot]@users.noreply.github.com}"
git -C "${WORKTREE_DIR}" commit -m "${COMMIT_MESSAGE}"
git -C "${WORKTREE_DIR}" push origin gh-pages
