
class Lesson {
  String title;
  String content;

  Lesson(
      {this.title,  this.content});
}

List getLessons() {
  return [
    Lesson(
        title: "Introduction to AI",
        content:
    """
    This course is a high-level overview of artificial intelligence (AI) for people with little or no knowledge of computer science and statistics. In it we’ll cover the essential concepts of AI and show you how to apply custom AI solutions with free, easy to use tools, all in your browser.
    The course will show you some some simple but powerful ways that data scientists make predictions about objects, people, and the future. Later, we’ll cover exciting, complex topics you may have heard of, such as neural networks, computer vision, deep learning, and unsupervised learning.
    In this lesson we’ll introduce you to some key concepts and get you trying out some AI tools.
    AI is the study of how to make computers perform tasks that humans consider difficult through the creation of intelligent agents. The study of AI began in the 1950s, and it has improved dramatically over time with better statistical methods and greater computing power.
    AI is now used for all sorts of things, such as intelligent opponents in video games, accurate medical diagnosis, speech commands on mobile phones, and keeping email inboxes clear of spam. People who use AI often want it to perform repetitive tasks that take a lot of time for a person to do, or to solve problems which seem almost impossible to solve with a calculator.
    """
    ),
    Lesson(
        title: "Machine Learning From Hero to Zero",
        content:
      """
      Machine learning is a subset of AI. When normal computer software needs to be improved, people edit it. Machine learning, on the other hand, is software that rewrites itself to get better at a specific task. For example, some online stores use machine learning to review your previous spending habits to give you personalised recommendations. There are lots of kinds of machine learning, including neural networks and deep learning.
      In short, neural networks are a type of machine learning algorithm, modelled on how we thought the human brain worked. Deep learning is a particular way of organizing a neural network, which can solve very difficult problems, like identifying faces from photos or videos.
      """
    ),
    Lesson(
        title: "Software Development for Dummies",
        content:
     """
     It’s essential for an Open Source project like this to run on Linux to gain publicity in the community. Since Mindscript is built around the cross-platform wxWidgets library, it can today be compiled on Linux. Full Linux support is scheduled for the end of 2005. However, due to the interpreting nature of the Mindscript system, all of the programs created in Mindscript are truly platform independent. This means that you can create your Mindscript Program on Windows today, and run them on Linux next year.
     """
    )

  ];
}