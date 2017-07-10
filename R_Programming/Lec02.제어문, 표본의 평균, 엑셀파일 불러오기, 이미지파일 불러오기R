#### Lecture 02. 제어문, 표본의 평균, 엑셀파일 불러오기, 이미지파일 불러오기

### 1강 복습

setwd('c:/r_exam') # set working directory. 워킹디렉토리 설정

rm(list=ls()) # environment에 올라와 있는 Value 지우기

library(KoNLP) # 라이브러리 호출.(import library) 한국어 자연어 처리
library(wordcloud) # 워드클라우드(단어 시각화)
library(stringi) 
library(stringr) # string형태 사용가능

txt = readLines('big.txt', encoding = 'UTF-8') # big.txt 파일을 데이터를 txt에 저장
length(txt)
length(iris)
ncol(iris)
nrow(iris)


## 텍스트마이닝의 퀄리티를 좌우하는 것은 '지식', 기법은 누가 하던지 비슷함

## 사전 작업

# 어떤 사전을 쓸 것인가? (사전 베이스이기 때문에 사전이 매우 중요)
# 신조어 등록, 분야별 전문용어

## 사용자 사전에 데이터 등록  ##
buildDictionary(user_dic = data.frame(c("빅데이터","ncn")), replace_usr_dic=T) 
# user_dic(사용자사전)에 빅데이터라는 단어를 등록

## 텍스트 핸들링
gsup # 단어 substitute (찾아 바꾸기)
grep # 단어 삭제
length # 일정 길이 이상만 출력


## 유사단어를 한 단어로 통일 
# (찾아바꾸기 활용)
## 불필요한 단어들 제거

txt0 = str_to_lower(txt)                 # 대문자를 소문자로
txt1 = gsub("빅데이타","빅데이터", txt0) # 빅데이타를 빅데이터로
txt1 = gsub("bigdata","빅데이터", txt1)  # bigdata를 빅데이터로 
txt1 = gsub("big data","빅데이터", txt1) # big data를 빅데이터로


## 정규표현식

txt1 = gsub("[[:digit:]","", txt1) # 숫자 지우기
txt1 = gsub("[A-z]","", txt1) # 영문자 지우기
txt1 = gsub("[[:punct:]]","", txt1) # 
txt1 = gsub("[a((\\d)+)]","", txt1) # a로 시작하되 숫자가 연속으로 나오는것 지우기
# [a((\\d)+)] : + 의 경우에는 숫자가 최소 한개는 있어야함
# [a((\\d)*)] : * 의 경우에는 숫자가 없어도 됨. a로만 시작하면 됨.
# [a((\\d)+) | a((\\s)+)] : or 연산가능.

txt1 = gsub("  "," ", txt1)


# (특수문자)
# gsup("  "," ", txt) : 스페이스 2개를 1개로
# nchar(txt) > 1

# iris[iris$Sepal.Length >= 7 ,1:2]

txt2 = txt1[str_length(txt1) > 1]

txt_e = extractNoun(txt2) # 명사 추출 / output --> list
                          # extractNoun은 JAVA가 설치되어 있어야 가능
txt_t = table(unlist(txt_e)) # 리스트형식을 깨기
txt_s = sort(txt_t, decreasing = T) # txt_t 소팅, 내림차순, 오름차순은 F

txt_s1 = txt_s[str_length(names(txt_s))>1] # 한글자 이상 추출

head(txt_s1) # 앞에서 부터 6개 추출
txt_h = head(txt_s1, 5) # 5개 추출

barplot(txt_h) # plot은 2차원이기 때문에 축이 2개 필요, barplot은 하나만 입력가능

pal = brewer.pal(7, "Set1")

wordcloud(names(txt_s1),txt_s1, col=pal, min.freq = 3
    , random.order = F, rot.per = 0.2, scale=c(5,0.8))

# scale = 글자 크기 지정 (최대글자, 최소글자) 큰글자는 더 커지고 작은글자는 더 작아지게 됨
# min.freq = 2 : 1글자 단어는 제외
# rot.per = 0.2 // 글자 회전 비율 (기본 0.1) , 90도로 꺾이는 비
# plot, wordcloud 로 시각화 
# 사각형으로 출력되는 이유 --> 원형에서 단어가 많아지면 사각형으로 서서히 바뀜
# wordcloud에 색깔을 넣고 싶다면 library 활용.

# 연관성 분석 --> 장바구니 분석
# 물건과 물건의 상관관계. 
# 마트에서는 고객이 마트에 오래 머물게 하도록 상관관계가 높은 물건을 멀리배치


### 제어문

## IF 문

x = 5

if (x>6) {
  print('TRUE')
  print('Hello')
} else {
  print('FALSE')
  print('Hello')
}


## FOR 문

x %in% c(1,4,7,5) # %in%는 x에 c(1,4,7,5) 값이 포함되어 있는지 검사하고 있다면 true를 반환한다.

sum = 0
for (i in seq(1, 100,3)){ #seq(시작값, 종료값, 증가값)
  sum = sum+i
  print(sum)
}


## WHILE 문

s = array(dim = c(1,50))  # 50개의 배열을 갖는 변수 s 선언
str(s)
for (i in 1:50){
  if(iris[i, 1] > 6){
  s[1,i] = 1              # TRUE의 경우 s값에 1 삽입
  } else {
  s[1,i] = 0
  }
}

s1 = ifelse(iris$Sepal.Length > 7, 1, 0) # ifelse(조건, true, false)

# 1부터 150까지 10번 추첨. --> 100번 반복 / 평균에 대한 평균
m2 = c()
for(i in 1:100){
ind1 = sample(1:150, 10, replace = T)
m1 = mean(ind1)
m2 = c(m2, m1)
}

# 평균에 대한 평균의 histogram --> 종모양
hist(m2)
mean(m2)

# 함수 정의, 호출
# is.numeric 값이 숫자 인지 아닌지 체크 numeric : 수
# is --> 확인해 달라! ~인지 아닌지 체크
# as --> 바꾸어 달라! 형변환

add <- function(a, b){
  if (is.numeric(a)&is.numeric(b)){
    return (a + b)
  }else{
    print("숫자를 입력해 주세요")
  }
}

add2 <- function(a, b){
  if(is.numeric(a)==T){
  add = a + b
    return (add)
  }else{
  add = paste(a, b, sep = '-')
    return (add)
  }
}

a<-3
b<-6
add1(3,8)
add1(a,b)
add2(3,8)
add2(a,b)

add0 = add2("abc", "sss")

sort() # 데이터를 정렬한다.

5/3
(5%%3 == 0) | (5%%3 == 1)
5%/%3
(x>=5) & (x<10)

rm(list=ls())

1:(2*pi)
x = seq(0, 2*pi, 0.01) # seq를 이용하여 정수 부분만 출력되는 것이 아니라 더 세분화
y = sin(x) + rnorm(length(x))

length(y)
length(x)

plot(x,y)


################################################################################################

### 엑셀 파일 불러오기
# 데이터 파일 읽어오는 방법은 제각기 다르다

data1 = read.table('clipboard') # 클립보드에 복사된 파일 출력.
data2 = read.csv('data1.csv')   # skip ~몇번째 줄부터 출력 , blank.line.skip 빈 줄 제거

str(data2)
names(data2) = c("x1","x2") #x1, x2로 제목 변경

# xlsx 패키지 다운로드. Packages --> Install --> xlsx --> Install
# library(xlsx)

data3 = read.xlsx('data1.xlsx', sheetIndex = 1) # skip 대신에 startRow를 사용

### 이미지 데이터 불러오기

iris3
str(iris3)
iris3[,,1] # setosa만 출력
iris3[1,1,] 

# install.packages('readbitmap') 이미지를 읽을 수 있는 패키지
# library('readbitmap')

bmp1 = read.bitmap('img7.bmp')

dim(bmp1) # dim은 dimension 차수를 의미. 3은 3차원.

jpg1 = read.bitmap('img7.jpg')
dim(jpg1)

png1 = read.bitmap('img7.png')
dim(png1)

png2 = read.bitmap('img7-1.png', channel = 4)
dim(png2)

jpg1_m = matrix(jpg1, nrow = 1, byrow = T) # byrow : 스캔방향 열방향 
png2_m = matrix(png2, nrow = 1, byrow = T) # byrow : 스캔방향 열방향 

jpg1_m[1, 1:10] # 각 픽셀당 변수로 되어 있음 --> 활용가능
                # 머신러닝 이미지 인식 알고리즘에 활용. 데이터 자체로 분석.
                # 사진을 찍는다면 규격이 다 다름 --> 데이터 셋을 만들어 주기 위해 통일시켜야 함
dim(jpg1_m)
dim(png2_m)

list1 = list.dirs('.', full.names = T) # 파일 경로에 ('.') 은 현재 경로라는 뜻이다.

for (i in 2:length(list1)){
list2 = list.files('.', full.names = T, include.dirs = T) # ./a1은 현재위치에서 a1폴더에 있는 파일 검색 parrern = '.jpg' 
list2
}
