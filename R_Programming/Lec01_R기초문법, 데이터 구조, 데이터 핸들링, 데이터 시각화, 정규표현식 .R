#### Lecture 01

### 기초적인 문법

# R에서는 일반적인 프로그래밍 언어에서 흔히 사용되는 정수, 부동소수, 문자열이 기본적으로
# 지원된다. 그외에도 자료처리에 적합한 자료구조인 벡터(vector), 행렬(matrix), 데이터 프레임
# (data frame), 리스트(list) 등이 있다.

# 변수 값 할당 <- , -> , <<- , ->>, =

# R의 기본형은 벡터이므로 이들 스칼라자료는 길이 1의 벡터로 볼 수 있다. 그러나 실제로는 
# 편하게 스칼라 자료라고 생각해도 큰 문제는 없다.

x1<-1 # x1에 1을 대입

2->x2 # x2에 2를 대입

x3 = 1:10 # x3에 1부터 10까지의 합 대입

(x4 = c(1,5,3,9)) # x4에 1,5,3,9 대입
                  # c는 벡터를 의미, R에서는 c()안에 원하는 인자들을 나열하여 정리.
                  # 모두 한가지 유형으로 들어가야 하며 다를 경우 자동으로 형 변환이 된다.

x4[2]

matrix(1:15, nrow=3)  # Matrix는 행렬을 생성하는 것이다.
x5=matrix(1:15, ncol=3, byrow=T)
x5
x5[2,3]
x5[c(2,4),3]
x5[-c(2,4),3] # -c(2,4)의 경우 c(2,4)의 행을 제외한 나머지 행 출력

a2 = "a" # a의 변수에 문자 저장
         # 상수를 가지고 있는 변수 : "스칼라"
a3 = 1 : 3 # a 의 변수에 1,2,3 저장 : "벡타" -- 한 행이 있고 여러 열이 있는 경우
a3[2]

str(a3) # 데이터 구조 -- 벡터형태
        # int [1:3] 1 2 3

a4 = matrix(1:15,nrow = 3) # 행과 열이 있는 구조
                           #  "메트릭스" 는 데이터구조가 모두 동일

str(a4) # 데이터 구조 -- 3차원 배열. [메트릭스 = 배열]
        # int [1:3, 1:5] 1 2 3 4 5 6 ...

a5 = a4[2,1]

str(a5) # a5는 메트릭스가 아니고 인트형으로 출력
        # int 2

## 값은 없는 행, 열, 차원(면)
a6 = array(dim = c(3,3,3))
str(a6) # logi [1:3, 1:3, 1:3] NA NA NA NA NA ...

##################### 위의 변수에서는 데이터타입이 모두 같아야 한다.##########################

a7 = data.frame(1:3, rep(1:3), LETTERS[5:7]) # 데이터 프레임 -- 열별로 다른 데이터 타입을 넣을 수 있다.
str(a7) # $ 표시. 다른 타입들이 나타난다.

# 'data.frame':	3 obs. of  3 variables:
# $ X1.3        : int  1 2 3
# $ rep.1.3.    : int  1 2 3
# $ LETTERS.5.7.: Factor w/ 3 levels "E","F","G": 1 2 3

# a1~a6 까지 모두 $표시를 시작으로 나타나지 않는다.

a9 = a7[2] # a7의 두번재열 a9에 저장
str(a9) # 데이터프레임 구조/
a9 = as.matrix(a7[2]) # 메트릭스로 변경 후 a7의 2번째 행을 a9으로 저장
str(a9) # 데이터프레임 구조가 아님. 인트형 
a9 = as.matrix(a7)

a7$X1.3

a8 = list(a=a, a2=a2, a3=a3, a4=a4, a6=a6) 
# list를 사용하면 모두 묶을 수 있다.
# a "= a" 라고 입력하는 것은 첫번째 list의 이름을 a라고 설정한다는 의미이다

str(iris) # 데이터프레임 구조
a10 = (iris[iris$Sepal.Length >= 6.5, ]) # iris[조건] 보여줘!
a11 = rownames(iris[which(iris$Sepal.Length >= 6.5), ]) # iris[조건] 보여줘!

table(iris$Sepal.Length >= 6.5) # true or false가 각각 몇 개인지 출력



### 평균 구하는 법과 임의 추출(복원/비복원)

x = table(iris$Species) # iris의 Sepecies의 각각의 갯수 구하기

str(iris) # str ==> structure

x1 = c(1,2,3,4,5,6,7,1000) # 1000은 이상치 이상치를 제거 해야함
sum(x1)/length(x1)
mean(x1)
# mean(x1) = sum(x1)/length(x1)
((n/2) + ((n/2)+1))/2 # 중앙값 구하기 (이상치 제거)
median(x1)
# median(x1) = ((n/2) + ((n/2)+1))/2 

sample(1:45, 6, replace = F) #로또 : 45개의 숫자중 6개 추출, 
                             #replace는 복원 비복원. 비복원으로 하면 다음 값에 영향


### iris에서 70%/30%에 해당하는 표본 추출


ind = sample(1:nrow(iris), 150, replace = F) # 1부터 nrow(iris) -- (iris 끝행의 수 150개)까지의 샘플 150개 추출 
                                             # 따라서 1부터 150개로 이루어진 iris의 순서를
                                             # Random하게 뒤섞는 것
A1 = iris[ind, ] 
View(iris)
View(A1)


ind1 = sample(1:nrow(iris), nrow(iris)*0.7, replace = F)

train = iris[ind1,]
test=iris[-ind1,]
View(train)
View(test)


### 데이터의 시각화 기법

summary(iris) # 1st qu. 상위 25%값, #3rd qu. 상위 75%값

hist(iris$Petal.Length) # 2개의 패턴으로 Gruoping 확인

boxplot(iris[,1:4]) #행 생략 --> 모든행에 대해서
                    # median 값이 까만선
                    # 하얀점은 이상치가 존재할 수 있다는 의미
                    # hist, boxplot --> 시각화 기법

View(iris)
A2 = iris
A2[,1:4] = scale(iris[,1:4]) # iris 표 정규화(Normalization)
View(A2)

str(iris)

nlevels(iris$Species) #레벨 number 확인
levels(iris$Species)  # 레벨 종류 확인

library(MASS)  # 패키지 다운로드 : 함수 호출
data("survey") # 메모리에 로딩
View(survey)

table(survey$Sex, survey$W.Hnd)      # 성별별 왼손잡이, 오른손잡이 수
t1 = table(survey$Sex, survey$Smoke) # 성별별 흡연자 수
                                     # 외관의 합계 = 주변 합 

prop.table(t1, 1) # prop. 은 확률을 구하는 함수
                  # (t1, margin) margin이 1이면 행의 합이 1
                  # margin이 2면 열의 합이 1

barplot(t1) # barplot

plot(iris$Petal.Length,iris$Sepal.Length) 

n = round((length(iris$Sepal.Length) * 0.1)/2,0)
# n = iris의 5%에 해당하는 갯수 
# round함수 (값,0) 0는 정수형

x1 = sort(iris$Sepal.Length) # 소트함수. 오름차순으로 순서대로 정렬한다.
x1[(n+1):(length(iris$Sepal.Length)-n)]
# 상위 하위 5%를 제외한 데이터 150개중 9번째부터 142번 까지.

x2 = sort(iris$Sepal.Length)
x2[1:length(iris$Sepal.Length)]

str(x1)

rnorm(1000) # 평균이 0로 표준편차가 1인 DATA
hist(rnorm(100000, mean = 100, sd = 3)) # 1시그마 - 68%   2시그마 - 95%
# rnorm 함수는 함수 모양을 정규분포와 비슷한 모양으로 만들어준다.

cor(iris[,1:4]) # 상관계수 구하기, [빈칸(모든행), 1부터 4까지]
                # 0.6이상이면 높은 상관계수라고 볼 수 있다.

cor.test(iris$Sepal.Length, iris$Petal.Length)


### list의 데이터구조

rm(list =ls()) # 오른쪽에 있는 Environment에 있는 Data 삭제. rm()은 하나하나 삭제


list1 = list(sp=1, sp2=c(1,3,5), y=c("A","B"))

list1[2]   # 첫번째 방안에 있는것을 가져와라.
list1$sp2  # 값만 출력할 수 있다. $sp2는 출력 안됨
list1[[2]] # 위와 같다.

list2 = list(x=list1, y=list1)
str(list2)
list2[1]        # 첫번째 리스트 출력 $x 출력
list2[[1]]      # 첫번째 리스트 출력
list2[[1]][[2]] # 첫번째 리스트 안에있는 두번째 리스트의 값 출력
                # 첫번째 결과의 2번째를 출력



### 네이버의 빅데이터-wiki를 받아서 big.txt파일로 저장 ==> 많이 나온 순서대로 시각화하기 

txt = readLines('big.txt', encoding = 'UTF-8') # txt변수에 test.txt 내용 저장
# txt안의 enter단위로 줄 인식. 마지막 줄에 꼭 enter넣기

str(txt)
txt[1] 
txt[10]


nchar(txt)               # 텍스트 안에 있는 각각의 char의 글자수 확인.
txt0 = txt[nchar(txt)>1] # 글자수 1이상인 것만 출력 (데이터 핸들링)
nchar(txt0)

#install.packages('KoNLP', dependencies = T) 
# 패키지 설치, NLP --> 자연어 처리

library(KoNLP)

txt_n = extractNoun(txt)
str(txt_n)

# 단어 빈도마다 시각화 하여 보여줌 ==> '워드 클라우드'

txt_t = table(unlist(txt_n))

#install.packages('wordcloud')
# 워드 클라우드 설치 (데이터를 시각화 패키지)

library(wordcloud)

wordcloud(names(txt_t), txt_t)

useSejongDic() # 세종사전 단어 등록(어떠한 것이 단어인지 인식하기 위해)

## 데이터 핸들링. ==> 단어를 다듬어야 하거나 무의미한 글자 제거 작업

txt1 = gsub("데이터","빅데이터",txt0) # 찾아 바꾸기. gsup([바꾸기전],[바꾼후],[텍스트위치])
txt1 = gsub('[A-z]','',txt1)          # ([]안에 있는 모든 것을 찾아달라, ''는 데이터 삭제)

txt1 = gsub("[[:digit:]]","",txt1) # delete digit character
txt1 = gsub("[[:punct:]]","",txt1) # delete punctuation character
txt1 = gsub("  "," ",txt1)

# 정규표현식에서 대괄호는 무조건 becasue 패턴이기 때문에.
# 정규표현식으로 패턴을 만들 수 있다. (regular expression)

# *참고*
# Character Classes Pattern	Meaning
# [[:alpha:]]	Match a letter character: [A-Za-z]
# [[:digit:]]	Match a digit character: [0-9]
# [[:xdigit:]]	Match a hexadecimal digit character: [0-9A-Fa-f]
# [[:alnum:]]	Match an alphanumeric character: [0-9A-Za-z]
# [[:lower:]]	Match a lower case character: [a-z]
# [[:upper:]]	Match an upper case character: [A-Z]
# [[:blank:]]	Match a blank (space or tab):[ \t]
# [[:space:]]	Match a whitespace character):[ \t\r\n\v\f]
# [[:punct:]]	Match a punctuation character: [-!"$%&'()*+,./:;<=>?@[\]_`{
# [[:graph:]]	Match Graphical character: [\x21-\x7E]
# [[:print:]]	Match Printable character (graphical characters and spaces)
# [[:cntrl:]]	Match control character
