# Copyright 1999-2023 Gentoo Authors and Alex313031
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 pypi

DESCRIPTION="A microframework based on Werkzeug, Jinja2 and good intentions"
HOMEPAGE="
	https://palletsprojects.com/p/flask/
	https://github.com/pallets/flask/
	https://pypi.org/project/Flask/
"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mitsuhiko/flask.git"
	inherit git-r3
else
	inherit pypi
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+examples -test +python3_9 +python_targets_python3_9"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-python/blinker-1.6.2[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-2.3.3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib-metadata-3.6.0[${PYTHON_USEDEP}]
	' 3.9)
	${PYTHON_DEPS}
"
BDEPEND="
	test? (
		>=dev-python/asgiref-3.2[${PYTHON_USEDEP}]
		!!dev-python/shiboken2[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}"

distutils_enable_sphinx docs \
	dev-python/pallets-sphinx-themes \
	dev-python/sphinx-issues \
	dev-python/sphinx-tabs \
	dev-python/sphinxcontrib-log-cabinet
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	if [[ ${EPYTHON} == python3.12 ]]; then
		EPYTEST_DESELECT+=(
			tests/test_basic.py::test_max_cookie_size
		)
	fi

	epytest -p no:httpbin
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
