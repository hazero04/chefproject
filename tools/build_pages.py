"""GitHub Pages(docs/)용 정적 PWA 데모 빌드 스크립트.

JSP 앱(Chef_Project/src/main/webapp)의 공통 리소스(CSS, 아이콘, 식재료 이미지)를
docs/assets 로 복사하고, SQL 시드 파일(insert.sql, recipe.sql)을 읽어
docs/data.js 를 생성한다. 디자인/데이터를 바꾼 뒤 다시 실행하면 된다.

    python3 tools/build_pages.py
"""
import json
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WEBAPP = ROOT / "Chef_Project" / "src" / "main" / "webapp"
RES = WEBAPP / "resources"
DOCS = ROOT / "docs"
ASSETS = DOCS / "assets"

COPY = {
    RES / "css" / "bootstrap.min.css": ASSETS / "css" / "bootstrap.min.css",
    RES / "css" / "grocery.css": ASSETS / "css" / "grocery.css",
    RES / "vendor": ASSETS / "vendor",
    RES / "icons": ASSETS / "icons",
    RES / "images": ASSETS / "images",
}

VALUE_RE = re.compile(r"'((?:[^']|'')*)'|(-?\d+(?:\.\d+)?)")


def sql_values(sql, table):
    """INSERT INTO <table> ... VALUES(...) 의 값 목록들을 순서대로 반환."""
    rows = []
    for m in re.finditer(r"INSERT\s+INTO\s+" + table + r"\b[^;]*?VALUES\s*\((.*?)\)\s*;", sql, re.S | re.I):
        vals = []
        for s, n in VALUE_RE.findall(m.group(1)):
            vals.append(s.replace("''", "'") if s or not n else (float(n) if "." in n else int(n)))
        rows.append(vals)
    return rows


def main():
    for src, dst in COPY.items():
        if dst.exists():
            shutil.rmtree(dst) if dst.is_dir() else dst.unlink()
        dst.parent.mkdir(parents=True, exist_ok=True)
        (shutil.copytree if src.is_dir() else shutil.copy2)(src, dst)

    food_sql = (RES / "sql" / "insert.sql").read_text(encoding="utf-8")
    recipe_sql = (RES / "sql" / "recipe.sql").read_text(encoding="utf-8")

    foods = [
        dict(name=v[0], description=v[1], price=v[2], date=v[3], place=v[4], stock=v[5], filename=v[6])
        for v in sql_values(food_sql, "food")
    ]
    recipes = [dict(name=v[0], ingredients=v[1], manual=v[2]) for v in sql_values(recipe_sql, "recipe")]

    data = "/* tools/build_pages.py 로 자동 생성된 파일입니다. 직접 수정하지 마세요. */\n"
    data += "window.CHEF_DATA = " + json.dumps({"foods": foods, "recipes": recipes}, ensure_ascii=False, indent=1) + ";\n"
    (DOCS / "data.js").write_text(data, encoding="utf-8")
    print(f"docs/ 빌드 완료: 식재료 {len(foods)}개, 레시피 {len(recipes)}개")


if __name__ == "__main__":
    main()
