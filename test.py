#!/usr/bin/env python3

import yaml

def dict_path(path, my_dict, jsonPathObject):
    # global jsonPath
    for k, v in my_dict.items():
        if isinstance(v, dict):
            if not path:
                key = k
            else:
                key = path + "_" + k
            dict_path(key, v, jsonPathObject)
        else :
            if not path:
                key = k
            else:
                key = path + "_" + k
            key = key.upper()
            jsonPathObject[key] = v
    return jsonPathObject

def readFile(filePath):
    with open(filePath) as variables:
        config = yaml.load(variables, Loader = yaml.FullLoader)
    variables.close()
    config = dict_path("", config, {})
    return config

def parseYml(globalConfigPath, appConfigPath):
    globalConfig = readFile(globalConfigPath)
    appConfig = readFile(appConfigPath)
    for k, v in appConfig.items():
        if k not in globalConfig['APP_PROTECTED_PROPERTIES']:
            globalConfig[k] = v
    writeVariables("", globalConfig)

def writeVariables(filePath, globalConfig):
    with open("file.sh", "w") as f:
        for k, v in globalConfig.items():
            if k != 'APP_PROTECTED_PROPERTIES':
                f.write("{}={}\n".format(k,v))
    f.close()
    print ('Environment variables are exported in .env file')

parseYml('env.yml', 'app.yml')