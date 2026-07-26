.PHONY: iso iso-docker clean test release help

REPO_ROOT := $(CURDIR)
OUTPUT_DIR := $(REPO_ROOT)/dist
WORK_DIR := $(REPO_ROOT)/work

help:
	@echo "Zog Build System"
	@echo ""
	@echo "Targets:"
	@echo "  make iso         - Build ISO (via CI on remote; local is slow on Apple Silicon)"
	@echo "  make iso-docker  - Build ISO locally in Docker (Apple Silicon: very slow)"
	@echo "  make test        - Boot-test ISO in QEMU (requires qemu)"
	@echo "  make clean       - Remove build artifacts"
	@echo "  make release     - Tag and push release (triggers CI)"
	@echo ""

iso: gen-packages sync-theming
	@echo "Building ISO requires mkarchiso on native x86_64 or Linux."
	@echo "For Apple Silicon, use GitHub Actions (recommended) or:"
	@echo "  make iso-docker"
	@exit 1

iso-docker: gen-packages sync-theming
	@echo "Building ISO in Docker (x86_64 emulated via OrbStack)..."
	@docker build -t zog-build -f docker/Dockerfile .
	@docker run --rm -v $(REPO_ROOT)/archiso:/work/archiso -v $(OUTPUT_DIR):/work/out zog-build

gen-packages:
	@bash scripts/gen-packages.sh

sync-theming:
	@bash scripts/sync-theming.sh || true

clean:
	rm -rf $(WORK_DIR) $(OUTPUT_DIR) archiso/packages.x86_64

test: iso
	@if command -v qemu-system-x86_64 >/dev/null 2>&1; then \
		bash test/qemu-boot-test.sh $(OUTPUT_DIR)/*.iso; \
	else \
		echo "QEMU not installed. Install with: brew install qemu"; \
		exit 1; \
	fi

release:
	@bash scripts/release.sh

.PHONY: gen-packages sync-theming
