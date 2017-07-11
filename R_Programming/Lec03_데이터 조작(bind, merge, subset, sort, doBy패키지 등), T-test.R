#### Lecture 03. 데이터 조작(bind, merge, subset, sort, doBy패키지 등), T-test

# is --> yes, no 검증
# as --> 변환

rm(list = ls())

write(iris, 'data1.xlsx')  # iris를 data1.csv 포멧으로 저장

methods(plot)

a1 = iris
a2 = cars

## save, load

save (a1, a2, file = 'a.rdata') # 쌍따옴표, 작은따옴표 둘다 허용
load('a.rdata')                 # 일일히 data를 등록할 필요없이 save한번에 해결


## rbind(), cbind() -- 강제로 값을 합침 / primary key에 의해 합치는 법은 merge

x1 = matrix(1:15, nrow = 5) # 기본값의 byrow는 F
x2 = matrix(1:15, nrow = 5, byrow = T)

y1 = rbind(x1, x2)
y1
y2 = cbind(x1, x2)
y2

x3 = c(1,3)
for(i in 1:10){
  x3 = c(x3, i)
}

x4 = c(1,2,3); x5=c(5,6,7)

rbind(x4, x5) # 열단위로 합침 (로우 = 열)
cbind(x4, x5) # 행단위로 합침 (컬럼 = 행)


## merge -- 공통된 키로 합쳐줌
xx <- data.frame ( name1 =c("a", "b", "c"), math =c(1, 2, 3))
yy <- data.frame ( name2 =c("c", "b", "a"), english =c(4, 5, 6))

cbind (xx, yy) # cbind는 그대로 열로 이어붙임.
merge(xx,yy, all = T, by.x='name1', by.y = 'name2') # 두 데이터 프레임을 공통된 키를 기준으로 묶는 함수. 
                                                    # 동일한 필드가 존재하지 않을때 by.x, by.y를 이용함


## subset() -- 부분집합을 만들어 줌 (원본 손상 없이)

s1 = subset(iris, Species == "setosa") # 없는 값에 대한 껍데기가 남아 있기 때문에 재정의 해주어야 한다
str(s1) # str(객체) : 데이터 구조, 변수 개수, 변수 명, 관찰치 개수, 관찰치의 미리보기
s1$Species = factor(s1$Species) # factor를 s1의 Species로 재정의.


## split() -- 데이터를 분리

s2 = split (iris , iris $ Species ) # Species를 기준으로 데이터 분리
str(s2) # str -- 데이터 구조 확인


## sort(), order() -- 데이터 정렬 함수

# sort()  -- 값 정렬 결과를 돌려 줌. 벡터 자체 변환시키지는 않음
# order() -- 인덱스(위치)값을 돌려줌. 

s3 = c(1, 5, 3, 7, 9, 2) 
sort(s3, decreasing = F)
order(s3, decreasing = F)  


## with(), within() 

mean(c(1:5, NA)) # NA 값이 들어가면 계산을 못함
mean(c(1:5, NA), na.rm = T) # na.rm = T 명령어는 NA를 제외시

# 평균값으로 NA넣는것 해보기

## attach(), detach() -- 인자로 주어진 데이터 프레임이나 리스트를 곧바로 접근, 해제

## which(), which.max(), which.min() -- 벡터 또는 배열에서 주어진 조건을 만족하는 값이 있는 곳의 색인을 찾는다.

# which
x <- c(2, 4, 6, 7, 10)
x %% 2
 
which (x %% 2 == 0) # 인덱스 출력

x[ which (x %% 2 == 0)] # 값 출

# which.max(), which.min() -- 어진 벡터에서 최소 또는 최대 값이 저장된 색인을 찾는함수
x <- c(2, 4, 6, 7, 10)
which.min (x)

x[ which.min (x)]

which.max (x)

x[ which.max (x)]


### apply() 함수들

## apply() -- 행렬의 행 또는 열방향으로 특정 함수를 적용

d <- matrix (1:9 , ncol =3)

for( i in 1:nrow(d)){   # 행단위/ 열단위로 평균을 구하려면 for loop를 돌려야 함
print(mean(d[i,]))      # apply() 함수를 사용한다면 손쉽게 해결 가능
}

apply(d, MARGIN = 1,sum) # 1이 행방향, 2가 열방향


## lapply() -- lapply(X, 함수)의 형태로 호출하며 이때 ‘X’는 벡터 또는 리스트이고, 
##'함수’는 ‘X’내각 요소에 적용할 함수이다. 함수를 적용한 결과는 리스트로 반환된다.

result <- lapply (1:3 , function (x) { x*2 })

## sapply() -- 기능은 lapply()와 동일결과를 벡터로 반환된다.

## tapply() -- 그룹별 처리를 위한 apply 함수로서 tapply(데이터, 색인, 함수)의 형태로 호출한다.

apply(d, 1, sum)
tapply(iris$Sepal.Length, iris$Species, sum) # 그룹별 총합
tapply(iris$Sepal.Length, iris$Species, min) # 그룹별 최소값

## mapply() -- mapply()는 sapply()와 유사하지만 다수의 인자를 함수에 넘긴다는데서 차이가 있다.

mapply ( function (i, s) {
   sprintf (" %d%s ", i, s)
   }, 1:3 , c("a", "b", "c"))


### doBy 패키지 by에 따라 요약정리, 정렬, 분리, 추출 등을 한다.

# install.packages('doBy')
# library(doBy)

# summaryBy

?summaryBy
summaryBy(iris)
summaryBy(.~Species, iris) # 종별로 집계, .은 전체 컬럼값
summaryBy(Sepal.Length~Species, iris) # Sepal.Length 컬럼 만

summaryBy(Sepal.Length~Species, iris, FUN = median) # 기본함수가 mean을 median으로 function 출력


# sampleBy

sample(1:20, 200, replace = T, prob = c(1, 3, 3, rep(1, 17))) # prob -- 확률, rep -- 1의 확률로 17번 반복
table(sample(1:20, 200, replace = T, prob = c(1, 3, 3, rep(1, 17)))) # 2와 3이 상대적으로 많이 추출

sampleBy(Sepal.Length~Species, data = iris, frac=0.1, systematic = T) # frac = 0.1 -- 10%의 데이터 임의로 추출
# systematic은 균일하게 추출 (대칭적으로)                          

## aggregate() -- doBy 패키지가 데이터를 그룹별로 나눈뒤 특정 계산을 적용하는 함수인 반면
#                 aggregate()는 보다 일반적인 그룹별 연산을 위한 함수이다.
#                 summaryBy와 같은 구조
aggregate ( Sepal.Width ~ Species , iris , mean )


## stack(), unstack() 

x <- data.frame ( medicine =c("a", "b", "c"), ctl=c(5, 3, 2) , exp=c(4, 5, 7))

x

stacked_x <- stack (x)
stacked_x
summaryBy ( values~ind , stacked_x)

unstack ( stacked_x, values ~ ind )


### reshape2 패키지

## melt() -- 인자로 데이터를 구분하는 식별자(id), 측정 대상 변수, 측정치를 받아 데이터를
#            간략하게 표현한다.
library ( reshape2 )
str( french_fries )
head ( french_fries )

## dcast() -- 피벗테이블

## RMySQL 패키지 -- DB와 연동하여 sql문을 사용 할 수 있다.

## sqldf 패키지  -- R에서 sql문을 사용 할 수 있다.
#install.packages ("sqldf")
#library (sqldf)

sqldf ("select distinct Species from iris") # 함수 안에서는 sql문법 사용
sqldf ("select avg(Sepal.Length) from iris where Species = 'setosa '") # Sepal.Length 는 . 때문에 에러발생

names(iris) = c('SL', 'SW', 'PL', 'PW','SP')

sqldf ("select avg(SL) from iris where SP = 'setosa'")

sqldf ("select SL,SP from iris where SL > 6 ")

# names(iris) = c('Sepal.Length', 'Sepal.Width', 'Petal.Length', 'Petal.Width', 'Species')
# 원래 이름으로 되돌리기


### plyr 패키지 -- 데이터를 분할하고(split), 분할된 데이터에 특정 함수를 적용한 뒤(apply), 
# 그 결과를 재 조합(combine)하는 세 단계로 데이터를 처리하는 함수들을 제공한다
  

###################################################################################################

library('MASS')
data("survey")
View(survey)

model1 = t.test(Height ~ Sex, survey)
model1 # 남자가 여자보다 키가 크다. t, df, p-value, confidence interval 등을 알아야 함
       
var.test(x=data1, y=data2) # 등분산인지 이분산인지 검정
                           # F --> 분산에 대한 비를 찾기 위해 등장
                           # 1로 부터 멀어질수록 두 숫자간의 차이가 남 --> 이분산 

data1 = rnorm(100, mean = 180, sd = 10)
data2 = rnorm(100, mean = 160, sd = 5)

t.test ## paired 동일한 환경에서 쌍으로 이루어 처리
       #  var.equal = T --> 등분산, val.equals = F --? 이분산
t.test(x=data1, mu=180 ) # p-value 가 0.05보다 크기 때문에 귀무가설을 채택.

t.test(x=data1, mu=200 ) # p-value 가 0.05보다 작기 때문에 귀무가설을 기각. 

t.test(x=data1, y=data2 ,var.equal = F) # 2-sample t-test
                                        # p < 0.05 이므로 두 성별의 키가 동일하다는 가설을 기각한다.
