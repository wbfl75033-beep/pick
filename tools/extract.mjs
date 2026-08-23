// index.html 안의 하드코딩 배열을 뽑아 db/seed.sql 로 만드는 스크립트
import fs from 'node:fs';

const html = fs.readFileSync('docs/original/index.original.html', 'utf8');

function grab(name) {
  const re = new RegExp('const\\s+' + name + '\\s*=\\s*\\[');
  const m = re.exec(html);
  if (!m) throw new Error('not found: ' + name);
  let i = m.index + m[0].length - 1; // '[' 위치
  let depth = 0, start = i;
  for (; i < html.length; i++) {
    const c = html[i];
    if (c === '[') depth++;
    else if (c === ']') { depth--; if (depth === 0) break; }
  }
  const src = html.slice(start, i + 1);
  return new Function('return ' + src)();
}

const data = {
  categories: grab('categories'),
  instructors: grab('instructors'),
  posters: grab('posters'),
  banners: grab('banners'),
  topAds: grab('topAds'),
};

fs.writeFileSync('tools/data.json', JSON.stringify(data, null, 2));
console.log('categories:', data.categories.length);
console.log('instructors:', data.instructors.length);
console.log('posters:', data.posters.length);
console.log('banners:', data.banners.length);
console.log('topAds:', data.topAds.length);
console.log('강사 샘플 키:', Object.keys(data.instructors[0]).join(', '));
console.log('영상 총 개수:', data.instructors.reduce((a,i)=>a+(i.videos?.length||0),0));
console.log('type 분포:', JSON.stringify(data.instructors.reduce((a,i)=>{a[i.type||'(없음)']=(a[i.type||'(없음)']||0)+1;return a;},{})));
console.log('사진 호스트:', [...new Set(data.instructors.map(i=>{try{return new URL(i.photo).host}catch{return '(없음)'}}))].join(', '));
