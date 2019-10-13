import time
import pandas as pd
import numpy as np

CITY_DATA = { 'chicago': 'chicago.csv',
              'new york city': 'new_york_city.csv',
              'washington': 'washington.csv' }

def get_filters():
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    print('Hello! Let\'s explore some US bikeshare data!')
    # TO DO: get user input for city (chicago, new york city, washington). HINT: Use a while loop to handle invalid inputs
    cities = ['chicago', 'new york city', 'washington']
    city = input('\nSelect the city you want to filter the bikeshare data by. \nChoose either chicago, new york city or washington?:  ').lower()
    while True:
        if city in cities:
            print("\nWe are working with {} data".format(city.upper()))
            break
        else:
            print('\nPlease choose a valid city, either chicago, new york city, or washington.')  
            break

    # TO DO: get user input for month (all, january, february, ... , june)
    months = ['january', 'february', 'march', 'april', 'may', 'june', 'all']
    month = input('Select the month you want to filter the bikeshare data by. \n Choose from the list: (january, february, march, april, may, June, all): ').lower()
    while True:
        if month in months:
            print('\nWe are working with {} data\n'.format(month.upper()))
            break
        else:
            print('\nPlease choose a valid month from the list (january, february, march, april, may, June, all): ')
            break
            
    # TO DO: get user input for day of week (all, monday, tuesday, ... sunday)
    days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'all']
    day = input('\nSelect the day of the week you want to filter the bikeshare data by. \n Choose from the list: (sunday, monday, tuesday, wednesday, thursday, friday, saturday, all): ').lower()
    while True:
        if day in days:
            print('\nWe are working with {} data\n'.format(day.upper()))
            break
        else:
            print('\nPlease choose a valid day of the week from the list (sunday, monday, tuesday, wednesday, thursday, friday, saturday, all)\n')
            break
    print('-'*40)
    return city, month, day


def load_data(city, month, day):
    """
    Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    # load data file into a dataframe
    data_file = CITY_DATA[city]
    df = pd.read_csv(data_file)
    
    # Convert 'Start Time' column to datetime
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    
    # extract month and day of week from Start Time to create new columns
    df['month'] = df['Start Time'].dt.month
    df['day_of_week'] = df['Start Time'].dt.weekday_name
    
    # filter by month if applicable 
    if month != 'all':
        # use the index of the months list to get the corresponding int
        months = ['january', 'february', 'march', 'april', 'may', 'june']
        month = months.index(month) + 1 
        # filter by month to create the new dataframe
        df = df[df['month'] == month]
    
    # filter by day of week if applicable
    if day != 'all':
        # filter by day of week to create the new dataframe
        df[df['day_of_week'] == day.title()]

    return df


def time_stats(df):
    """Displays statistics on the most frequent times of travel."""

    print('\nCalculating The Most Frequent Times of Travel...\n')
    start_time = time.time()

    # TO DO: display the most common month
    most_common_month = df['month'].mode()[0]
    print('The most common month is: {}'.format(most_common_month))

    # TO DO: display the most common day of week
    most_common_day = df['day_of_week'].mode()[0]
    print('The most common day of the week is: {}'.format(most_common_day))

    # TO DO: display the most common start hour
    df['hour'] = df['Start Time'].dt.hour
    most_common_hour = df['hour'].mode()[0]
    print('The Most Common Start Hour: {}'.format(most_common_hour))
    
    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print('\nCalculating The Most Popular Stations and Trip...\n')
    start_time = time.time()

    # TO DO: display most commonly used start station
    popular_start_station = df['Start Station'].value_counts().idxmax()
    print('The most commomly used start station is: {}'.format(popular_start_station))

    # TO DO: display most commonly used end station
    popular_end_station = df['End Station'].value_counts().idxmax()
    print('The most commomly used end station is: {}'.format(popular_end_station) )

    # TO DO: display most frequent combination of start station and end station trip
    most_frequent_trip = (df['Start Station'] + " --- " + df['End Station']).value_counts().idxmax()
    print('The most frequent combination of start station and end station trip is: {}'.format(most_frequent_trip))
    
    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def trip_duration_stats(df):
    """Displays statistics on the total and average trip duration."""

    print('\nCalculating Trip Duration...\n')
    start_time = time.time()

    # TO DO: display total travel time
    total_travel_time = sum(df['Trip Duration'])
    print('Total travel time is: {}'.format(total_travel_time))

    # TO DO: display mean travel time
    mean_travel_time = df['Trip Duration'].mean()
    print('Mean travel time is: {}'.format(mean_travel_time))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def user_stats(df):
    """Displays statistics on bikeshare users."""

    print('\nCalculating User Stats...\n')
    start_time = time.time()

    # TO DO: Display counts of user types
    user_types = df['User Type'].value_counts()
    print('User Type: {}'.format(user_types))

    # TO DO: Display counts of gender
    if 'Gender' in df.columns:
        gender = df['Gender'].value_counts()
        print('Genders: {}'.format(user_types))

    # TO DO: Display earliest, most recent, and most common year of birth
    # YOB abbreviates Year Of Birth
    # Ony the Chicago and New York City files have the Gender and Birth Year columns
    if 'Birth Year' in df.columns:
        earliest_YOB = df['Birth Year'].min()
        most_recent_YOB = df['Birth Year'].max()
        most_common_YOB = df['Birth Year'].mode()[0]
        print("\nThe earliest year of birth is: {}".format(str(earliest_YOB)))
        print("\nThe most recent year of birth is: {}".format(str(most_recent_YOB)))
        print("\nThe most common year of birth is: {}".format(str(most_common_YOB)))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)
# Function to display raw data upon request.    
def display_raw_data(df):    
    counter = 0
    user_input = input('\nDo you want to see 5 lines of raw data? Enter yes or no.\n').lower() 
    while True :
        if user_input != 'no':
            print(df.iloc[counter : counter + 5])
            counter += 5
            user_input = input('\nDo you want to see more raw data? Enter yes or no.\n')
        else:
            break

def main():
    while True:
        city, month, day = get_filters()
        df = load_data(city, month, day)

        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)
        display_raw_data(df)

        restart = input('\nWould you like to restart? Enter yes or no.\n')
        if restart.lower() != 'yes':
            break


if __name__ == "__main__":
	main()
