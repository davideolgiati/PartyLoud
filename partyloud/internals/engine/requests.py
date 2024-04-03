import random
from .versions import mac_names, windows_names, firefox, chrome


def generate_user_agent():
    user_agent = "Mozilla/5.0 ("
    platform = random.choice(["Windows", "Mac", "Linux"])
    is_32_bit = random.choice([True, False])
    browser = random.choice(["Firefox", "Chrome"])

    if platform == "Mac":
        os = f"Macintosh; Intel Mac OS X {random.choice(mac_names)}"
    else:
        if platform == "Linux":
            os = f"X11; Linux {'i686' if is_32_bit else 'x86_64'}"
        else:
            os = f"Windows NT {random.choice(windows_names)}{'' if is_32_bit else ' Win64; x64'}"

    if browser == "Firefox":
        ff_ver = random.choice(firefox)
        browser = f"; rv:{ff_ver}) Gecko/20100101 Firefox/{ff_ver}"
    else:
        browser = f") AppleWebKit/537.36 (KHTML, like Gecko) Chrome/{random.choice(chrome)} Safari/537.36"

    return f"{user_agent}{os}{browser}"


def cleanup(candidates, blocklist):
    # TODO: use a db for this, it's much better aand faster
    tmp = filter(lambda x: x.strip() != "", candidates)
    tmp = filter(lambda x: "http://" not in x.strip(), tmp)
    for word in blocklist:
        tmp = filter(lambda x: word not in x.strip(), tmp)

    return tmp


def fire_request_engine():
    pass
