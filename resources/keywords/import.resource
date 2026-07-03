*** Settings ***
Resource     web/login_keywords.resource
Resource     api/api_keywords.resource
Resource     mobile/appium_keywords.resource
Variables    ../data/common/config.yaml

*** Variables ***
${ENV}    sit