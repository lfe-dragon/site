VERSION = 0.0.1
PROJECT = dragon
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)

include priv/make/docs.mk
