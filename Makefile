.PHONY: update
update:
	git add .
	nix-on-droid switch --flake .
